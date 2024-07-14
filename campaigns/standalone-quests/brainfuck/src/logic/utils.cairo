use core::traits::Into;

const MASK_8: felt252 = 0xff;

use array::ArrayTrait;
use starknet::storage_access::StorePacking;

fn felt252_to_string(input : @Array<felt252>) -> Array<u8> {
    
    let mut output = ArrayTrait::new();
    
    let mut index = 0;
    loop {
        let mut c : felt252 = *input[index];
        let mut c : u256 = c.into();
        let mut temp = ArrayTrait::new();
        loop {
            if c == 0 {
                break;
            }
            let char : u8 = (c % 256).try_into().unwrap();
            temp.append(char);
            c /= 256;
        };

        
        let mut len = temp.len();

        loop {
            if len == 0 {
                break;
            }
            len -= 1;
            let char : u8 = *temp[len];
            output.append(char);
        };




        index += 1;
        if index == input.len() {
            break;
        }
    };

    output
}


// Use this file to hold any helper functions/types
