module vamsi_addr::StringUtilities {
    use std::string::{Self, String};
    use std::vector;

    struct StringStorage has store, key {
        stored_string: String,
        operation_count: u64,
    }

    public fun initialize_storage(owner: &signer, initial_string: vector<u8>) {
        let storage = StringStorage {
            stored_string: string::utf8(initial_string),
            operation_count: 0,
        };
        move_to(owner, storage);
    }

    
    public fun concatenate_strings(
        _owner: &signer, 
        owner_address: address, 
        second_string: vector<u8>
    ) acquires StringStorage {
        let storage = borrow_global_mut<StringStorage>(owner_address);
        
        
        let current_bytes = *string::bytes(&storage.stored_string);
        let second_bytes = second_string;
        
        
        vector::append(&mut current_bytes, second_bytes);
        
        
        storage.stored_string = string::utf8(current_bytes);
        storage.operation_count = storage.operation_count + 1;
    }

    
    public fun get_string_length(owner_address: address): u64 acquires StringStorage {
        let storage = borrow_global_mut<StringStorage>(owner_address);
        let string_bytes = string::bytes(&storage.stored_string);
        let length = vector::length(string_bytes);
        
        
        storage.operation_count = storage.operation_count + 1;
        
        length
    }

    
    #[view]
    public fun view_stored_string(owner_address: address): String acquires StringStorage {
        let storage = borrow_global<StringStorage>(owner_address);
        storage.stored_string
    }

}
