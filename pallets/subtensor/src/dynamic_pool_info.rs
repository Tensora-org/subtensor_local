use super::*;
use frame_support::{pallet_prelude::{Decode, Encode}, IterableStorageMap};
extern crate alloc;
use codec::Compact;

#[derive(Decode, Encode, PartialEq, Eq, Clone, Debug)]
pub struct DynamicPoolInfo {
    pub alpha_issuance: Compact<u64>,
    pub alpha_outstanding: Compact<u64>,
    pub alpha_reserve: Compact<u64>,
    pub tao_reserve: Compact<u64>,
    pub k: Compact<u128>,
    pub price: Compact<u128>,
    pub netuid: Compact<u16>,
}

impl<T: Config> Pallet<T> {
    pub fn get_dynamic_pool_info(netuid: u16) -> Option<DynamicPoolInfo> {
        if !Self::if_subnet_exist(netuid) {
            return None;
        }

        let alpha_issuance: u64 = Self::get_alpha_issuance(netuid);
        let alpha_outstanding: u64 = Self::get_alpha_outstanding(netuid);
        let alpha_reserve: u64 = Self::get_alpha_reserve(netuid);        
        let tao_reserve: u64 = Self::get_tao_reserve(netuid);
        let k: u128 = Self::get_pool_k(netuid);
        let price = Self::get_tao_per_alpha_price(netuid).to_num::<u128>();

        // Return the dynamic pool info.
        Some(DynamicPoolInfo {
            alpha_issuance: Compact(alpha_issuance),
            alpha_outstanding: Compact(alpha_outstanding),
            alpha_reserve: Compact(alpha_reserve),
            tao_reserve: Compact(tao_reserve),
            k: Compact(k),
            price: Compact(price),
            netuid: Compact(netuid),
        })
    }

    
    pub fn get_all_dynamic_pool_infos() -> Vec<Option<DynamicPoolInfo>> {
        let mut all_pool_infos = Vec::new();

        for (netuid, added) in <NetworksAdded<T> as IterableStorageMap<u16, bool>>::iter() {
            if added {
                let pool_info = Self::get_dynamic_pool_info(netuid);
                all_pool_infos.push(pool_info);
            }
        }

        all_pool_infos
    }
}