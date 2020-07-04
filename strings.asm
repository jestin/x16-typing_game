; store the strings in !raw so that they are stored in ascii
.str_test !raw "test",0
.str_hello_world !raw "hello world",0 
.str_another_string !raw "this is another string",0 

string_map:
!word .str_test
!word .str_hello_world
!word .str_another_string
