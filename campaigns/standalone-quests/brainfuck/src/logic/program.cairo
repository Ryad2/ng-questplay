use core::traits::Into;
use core::option::OptionTrait;
use core::traits::TryInto;
use core::array::ArrayTrait;
use src::logic::utils::felt252_to_string;
use  starknet::storage_access;
use core::dict::Felt252DictTrait;

trait ProgramTrait {
    fn check(self: @Array<felt252>);
    fn execute(self: @Array<felt252>, input: Array<u8>) -> Array<u8>;
}

// Implement ProgramTrait here
impl Program of ProgramTrait {

    fn check(self: @Array<felt252>) {

        // Vérifier les caractères non autorisés et l'équilibrage des crochets
        let mut balance : u32 = 0;
        let mut index = 0;
        let char0 : u8 = '+';
        let char1 : u8 = '-';
        let char2 : u8 = '>';
        let char3 : u8 = '<';
        let char4 : u8 = '.';
        let char5 : u8 = ',';
        let char6 : u8 = '[';
        let char7 : u8 = ']';
        let string : Array<u8>  = felt252_to_string(self);


        loop {
            let c : u8 = *string[index];
            if c == char0 || c == char1 || c == char2 || c == char3 || 
                c == char4 || c == char5 {
                } 
            else if c == char6 {
                balance = balance + 1;
            }
            else if c == char7 {
                balance -= 1;
                if balance < 0 {
                    panic!("Unmatched closing bracket");
                }
            }
            else {
                panic!("Invalid character in program");
            }
            index = index + 1;
            if index == string.len() {
                break;
            }
        };

        if balance != 0 {
            panic!("Unmatched opening bracket");
        }
    }



    fn execute(self: @Array<felt252>, input: Array<u8>) -> Array<u8> {

        // Initialisation de la mémoire
        let insctructions : Array<u8>  = felt252_to_string(self);
        let mut memory : Felt252Dict<u8> = Default::default();
        let mut output : Array<u8> = ArrayTrait::new();
        let mut input : Array<u8> = input;

        let mut index = 0;
        loop {
            
            memory.insert(index, 0);
            index += 1;
            if index == 256 {
                break;
            }
        };

        let mut index = 0;
        let mut pointer  = 0;
        
        loop {
            let instruction : u8 = *insctructions[index];

            if instruction == '+' {
              memory.insert(pointer, memory.get(pointer) + 1);
            }
            else if instruction == '-' {
                memory.insert(pointer, memory.get(pointer) - 1);
            }
            else if instruction == '>' {
                pointer += 1;
            }
            else if instruction == '<' {
                pointer -= 1;
            }
            else if instruction == '.' {
                let char : u8 = memory.get(pointer);
                output.append(char);
            }


            else if instruction == ',' {
                let char : u8 = input.pop_front().unwrap();
                memory.insert(pointer, char);
            }


            else if instruction == '[' {
                if memory.get(pointer) == 0 {
                    let mut balance : u32 = 1;
                    loop {
                        index += 1;
                        let instruction : u8 = *insctructions[index];
                        if instruction == '[' {
                            balance += 1;
                        }
                        else if instruction == ']' {
                            balance -= 1;
                            if balance == 0 {
                                break;
                            }
                        }
                    };
                
                }

            }


            else if instruction == ']' {
                if memory.get(pointer) != 0 {
                    let mut balance : u32 = 1;
                    loop {
                        index -= 1;
                        let instruction : u8 = *insctructions[index];
                        if instruction == ']' {
                            balance += 1;
                        }
                        else if instruction == '[' {
                            balance -= 1;
                            if balance == 0 {
                                break;
                            }
                        }
                    };
                
                }
            }
            else {
                panic!("Invalid character in program");
            }
            //end of reading insctructions
            index += 1;
            if index == 100 {//change to insctructions.len() when it works
                break;
            }
        };

        output
    }

}