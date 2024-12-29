#[starknet::interface]
pub trait IBankatToken<TContractState> {}

#[starknet::contract]
mod BankatToken {
    use core::starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl BankatTokenImpl of super::IBankatToken<ContractState> {}
}
