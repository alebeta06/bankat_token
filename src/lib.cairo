// Importa el tipo `ContractAddress` necesario para manejar direcciones de contratos en StarkNet.
use starknet::ContractAddress;

// Define la interfaz `IBankatToken`, que contiene un método llamado `mait`.
// Este método permite acuñar (`mint`) nuevos tokens y asignarlos a un destinatario.
#[starknet::interface]
pub trait IBankatToken<TContractState> {
    fn mait(ref self: TContractState, recipient: ContractAddress, amount: u256);
}

// Configura el componente ERC20 para manejar las funcionalidades estándar de tokens ERC20.
// Define el almacenamiento y los eventos asociados a este componente.
#[starknet::contract]
mod BankatToken {
    use openzeppelin::token::erc20::{ERC20Component, ERC20HooksEmptyImpl};
    use starknet::ContractAddress;

    component!(path: ERC20Component, storage: erc20, event: ERC20Event);

    // Define el almacenamiento del contrato. Utiliza una subestructura `erc20`
    // para almacenar los datos relacionados con las operaciones ERC20 (como balances y
    // aprobaciones).
    #[storage]
    struct Storage {
        #[substorage(v0)]
        erc20: ERC20Component::Storage,
    }

    // Declara un enum `Event` que encapsula los eventos emitidos por el componente ERC20.
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        ERC20Event: ERC20Component::Event,
    }

    // Constructor del contrato: inicializa el componente ERC20 con un nombre y símbolo para el
    // token.
    #[constructor]
    fn constructor(ref self: ContractState) {
        self.erc20.initializer("Bankat Token", "BKT");
    }

    // Implementa las funciones públicas estándar del token ERC20, como transferencias,
    // consultas de balance y transferencias aprobadas.
    #[abi(embed_v0)]
    impl ERC20Impl = ERC20Component::ERC20MixinImpl<ContractState>;

    // Implementa las funcionalidades internas del componente ERC20.
    impl ERC20InternalImpl = ERC20Component::InternalImpl<ContractState>;

    // Implementa la lógica de `mait` definida en la interfaz `IBankatToken`.
    // Llama al método `mint` del componente ERC20 para acuñar nuevos tokens y asignarlos al
    // destinatario.
    #[abi(embed_v0)]
    impl BankatTokenImpl of super::IBankatToken<ContractState> {
        fn mait(ref self: ContractState, recipient: ContractAddress, amount: u256) {
            self.erc20.mint(recipient, amount);
        }
    }
}
