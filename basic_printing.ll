

define i32 @compute(i32 %a,i32 %b){
    entry:
        %s= add i32 %a,%b
        %cm = icmp sgt i32 %s, 15

        br i1 %cm, label %if_true,label %if_false

    if_true:
        ret i32 %s    

    if_false:
        ret i32 0
}

@.str = private constant [4 x i8] c"%d\0A\00"  ; Define a format string for printing integers

declare i32 @printf(i8*, ...)  ; Declare printf function

define i32 @main() {
    %result = call i32 @compute(i32 5, i32 20)  ; Call compute function
    %format_ptr = getelementptr [4 x i8], [4 x i8]* @.str, i32 0, i32 0
    call i32 (i8*, ...) @printf(i8* %format_ptr, i32 %result)  ; Print result
    ret i32 0
}








