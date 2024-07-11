use core::traits::TryInto;
use core::array::ArrayTrait;

trait ProgramTrait {
    fn check(self: @Array<felt252>);
    fn execute(self: @Array<felt252>, input: Array<u8>) -> Array<u8>;
}

// Implement ProgramTrait here
impl Program of ProgramTrait {

    fn check(self: @Array<felt252>) {
        // Vérifier les caractères non autorisés et l'équilibrage des crochets
        let mut balance = 0;
        let mut index = 0;
        loop {
            let c : u32 = self.get(index).try_into();
            if c == 43 || c == 45 || c == 62 || c == 60 || c == 46 || c == 44 || c == 91 {

            } 
            match c {
                '+' => {},  // '+'
                45 => {},  // '-'
                62 => {},  // '>'
                60 => {},  // '<'
                46 => {},  // '.'
                44 => {},  // ','
                91 => {    // 
                    balance += 1;
                },
                93 => {    // 
                    balance -= 1;
                    if balance < 0 {
                        panic!("Unmatched closing bracket");
                    }
                },
                _ => {
                    panic!("Invalid character in program");
                }
            }
            index += 1;
            if index == self.len() {
                break;
            }
        }
        if balance != 0 {
            panic!("Unmatched opening bracket");
        }
    }







    fn execute(self: @Array<felt252>, input: Array<u8>) -> Array<u8> {
        // Initialisation de la mémoire
        let returnal : Array<u8>  = array![0];
        return returnal;
    }

}