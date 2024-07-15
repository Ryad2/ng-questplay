#[starknet::interface]
trait IBrainfuckVM<TContractState> {
    fn deploy(ref self: TContractState, program: Array<felt252>) -> u8;
    fn get_program(self: @TContractState, program_id: u8) -> Array<felt252>;
    fn call(self: @TContractState, program_id: u8, input: Array<u8>) -> Array<u8>;
}

#[starknet::contract]
mod BrainfuckVM {
    use core::option::OptionTrait;
    use core::traits::TryInto;
    use core::dict::{Felt252Dict, Felt252DictTrait};
    use super::super::super::logic::program::ProgramTrait;
    use core::nullable::{NullableTrait, match_nullable, FromNullableResult};
    // Implement BrainfuckVM Here



    #[storage]
    struct Storage {
        programs : Felt252Dict<Nullable<Program>>,
        program_counter: u8,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {        
        self.program_counter.write(0_u8);
        let emptyMap : Felt252Dict<Nullable<Program>> = Default::default();
        self.programs.write(emptyMap);
    }

    #[derive(Drop, Serde, Debug, Clone, Copy, starknet::Store)]
    struct Program {
        code : Array<felt252>,
    }

    #[abi(embed_v0)]
    impl IBrainfuckVMImpl of super::IBrainfuckVM<ContractState> {

        fn deploy(ref self: ContractState, program: Array<felt252>) -> u8 {
            ProgramTrait::check(@program);
            let counter = self.program_counter.read();
            let new_counter = counter + 1;
            let new_program = Program { code : program };
            let mut temp : Felt252Dict<Nullable<Program>> = self.programs.read();
            temp.insert(new_counter.into(), NullableTrait::new(new_program));
            self.programs.write(temp);

            return new_counter;
        }



        fn get_program(self: @ContractState, program_id: u8) -> Array<felt252> {
            let mut progs  = self.programs.read();
            let mut prog = progs.get(program_id.into());

            match match_nullable(prog) {
                FromNullableResult :: Null => panic!("there is no program here!!"),
                FromNullableResult :: NotNull(prog) => prog.unbox().code,
            }
        }


        fn call(self: @ContractState, program_id: u8, input: Array<u8>) -> Array<u8> {
            let Program = self.get_program(program_id);

            ProgramTrait::execute(@Program, input)
        }
        
    }

}