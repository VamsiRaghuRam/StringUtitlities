module vamsi_addr::StringUtilities {
    use std::string::{Self, String};
    use std::vector;

    /// Struct to store string data and operations
    struct StringStorage has store, key {
        stored_string: String,
        operation_count: u64,
    }

    /// Function to initialize string storage for a user
    public fun initialize_storage(owner: &signer, initial_string: vector<u8>) {
        let storage = StringStorage {
            stored_string: string::utf8(initial_string),
            operation_count: 0,
        };
        move_to(owner, storage);
    }

    /// Function to concatenate two strings and store the result
    public fun concatenate_strings(
        _owner: &signer, 
        owner_address: address, 
        second_string: vector<u8>
    ) acquires StringStorage {
        let storage = borrow_global_mut<StringStorage>(owner_address);
        
        // Get bytes from current string and new string
        let current_bytes = *string::bytes(&storage.stored_string);
        let second_bytes = second_string;
        
        // Concatenate byte vectors
        vector::append(&mut current_bytes, second_bytes);
        
        // Create new string and update storage
        storage.stored_string = string::utf8(current_bytes);
        storage.operation_count = storage.operation_count + 1;
    }

    /// Function to get the length of stored string and update operation count
    public fun get_string_length(owner_address: address): u64 acquires StringStorage {
        let storage = borrow_global_mut<StringStorage>(owner_address);
        let string_bytes = string::bytes(&storage.stored_string);
        let length = vector::length(string_bytes);
        
        // Update operation count
        storage.operation_count = storage.operation_count + 1;
        
        length
    }

    // View function to get stored string (read-only)
    #[view]
    public fun view_stored_string(owner_address: address): String acquires StringStorage {
        let storage = borrow_global<StringStorage>(owner_address);
        storage.stored_string
    }
}