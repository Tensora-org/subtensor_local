import bittensor as bt
import os
import pexpect
import traceback
import sys
import time

PASSWORD = "pass_me_the_keys"

def register_subnetwork() -> int:

    command = f'btcli subnet create --subtensor.network ws://127.0.0.1:9944 --wallet.name "validators'
    
    try:
        child = pexpect.spawn(command, timeout=60)
        child.logfile_read = sys.stdout.buffer 

        child.expect(r':')
        child.sendline('y')
        print(f'Accepted prompt to proceed on subnet registration\n')

        child.expect(r':')
        child.sendline(PASSWORD)
        print(f'Supplied password\n')

        child.expect(pexpect.EOF)
        print(f'Successfully registered subnet')
        return True
    except pexpect.exceptions.TIMEOUT:
        print(f'Error: Timed out while waiting for the prompt during the registration process for subnet')
        return False
    except pexpect.exceptions.EOF:
        print(f'Error: Unexpected end of output while interacting with the registration process for subnet')
        return False

def _register_hotkey(net_uid, wallet, hotkey):

    command = f"btcli s register --subtensor.network ws://127.0.0.1:9944 --netuid {net_uid} --wallet.name {wallet} --wallet.hotkey {hotkey}"

    attempts = 1
    regged = False
    wallet = bt.wallet(name=wallet, hotkey=hotkey)
    while regged == False:
        try:
            print(f"Attempt {attempts} to register {hotkey}")
            child = pexpect.spawn(command, timeout=60)
            child.logfile_read = sys.stdout.buffer 

            child.expect(r':')
            child.sendline('y')
            print(f'Accepted prompt to proceed on net_uid {net_uid}\n')

            child.expect(r':')
            child.sendline(PASSWORD)
            print(f'Supplied password for hotkey {hotkey}\n')

            child.expect(r':')
            child.sendline('y')
            print(f'Confirmed final registration step on net_uid {net_uid}\n')

            child.expect(r':')
            child.sendline('n')

            child.expect(pexpect.EOF)
            
            connection = bt.subtensor(network="ws://127.0.0.1:9944")
            
            if connection.is_hotkey_registered_any(wallet.get_hotkey().ss58_address):
                print(
                    f"Registered hot_key {hotkey} in {attempts}. Block number {connection.block}"
                )
                regged = True
            else:
                print(f"Registration failed, attempting again for {hotkey}")
                attempts += 1
                time.sleep(30)

        except pexpect.exceptions.TIMEOUT:
            print(f'Error: Timed out while waiting for the prompt during the registration process for net_uid {net_uid}.')
            return False
        except pexpect.exceptions.EOF:
            print(f'Error: Unexpected end of output while interacting with the registration process for net_uid {net_uid}.')
            return False

    return True

def register_miner_hotkeys(net_uid):

    for i, hotkey in enumerate(os.listdir("/home/ubuntu/.bittensor/wallets/miners/hotkeys")):

        if int(hotkey[-1:]) == 1 or int(hotkey[-1:]) == 4:
            continue
        
        _register_hotkey(net_uid, "miners", hotkey)

    print("Finished registering all hotkeys")

def register_validator_hotkey(net_uid):

    regged = _register_hotkey(net_uid, "validators", "validator_1")

    # add staking here

    if regged:
        print("Successfully registered Validator")
    else:
        print("Didn't manage to reg validator")

def add_stake():

    command = f"btcli stake add --wallet.name validators --wallet.hotkey validator_1 --subtensor.network ws://127.0.0.1:9944"

    try:
        child = pexpect.spawn(command, timeout=60)
        child.logfile_read = sys.stdout.buffer 

        child.expect(r':')
        child.sendline('y')
        print(f'Accepted prompt to proceed with stake\n')

        child.expect(r':')
        child.sendline('y')
        print(f'Confirmed staking\n')

        child.expect(r':')
        child.sendline(PASSWORD)
        print(f'Supplied password for validator\n')

        child.expect(r':')
        child.sendline('y')
        print(f'Confirmed staking\n')

        child.expect(pexpect.EOF)

    except pexpect.exceptions.TIMEOUT:
        print(f'Error: Timed out while waiting for the prompt during the registration process for net_uid {net_uid}.')
        return False
    except pexpect.exceptions.EOF:
        print(f'Error: Unexpected end of output while interacting with the registration process for net_uid {net_uid}.')
        return False



if __name__ == "__main__":

    # register_subnetwork()

    base = 360

    while True:

        s = bt.subtensor(network="ws://127.0.0.1:9944")

        current = s.block

        if current > (base):
            for i in range(0, 3):
                register_miner_hotkeys(1)

            base += 360
        else:
            print(f"sleeping for {base - current} blocks")
            time.sleep(11.9 * (base - current))
    
    register_validator_hotkey(1)

    # add_stake()

    register_miner_hotkeys(1)
