%Stack = type { i32, ptr }  ; Only store value and next pointer

@.str_num = private constant [4 x i8] c"%d \00"
@.str_newline = private constant [2 x i8] c"\0A\00"

declare i32 @printf(ptr, ...)
declare ptr @malloc(i32)
declare void @free(ptr)

define void @push(i32 %data, ptr %Ptr) {
entry:
    %head = load ptr, ptr %Ptr

    ; Allocate memory for the new node
    %sizeT = getelementptr %Stack, ptr null, i32 1
    %bytes = ptrtoint ptr %sizeT to i32
    %newNode = call ptr @malloc(i32 %bytes)

    ; Store value
    %valStore = getelementptr %Stack, ptr %newNode, i32 0, i32 0
    store i32 %data, ptr %valStore

    ; Link new node to the stack
    %nextPtr = getelementptr %Stack, ptr %newNode, i32 0, i32 1
    store ptr %head, ptr %nextPtr

    ; Update head pointer
    store ptr %newNode, ptr %Ptr
    ret void
}

define i1 @is_empty(ptr %Ptr) {
    %head = load ptr, ptr %Ptr
    %check = icmp eq ptr %head, null

    br i1 %check, label %empty, label %notEmpty

    empty:
        %format_ptr = getelementptr [4 x i8], ptr @.str_num, i32 0, i32 0
        call i32 (ptr, ...) @printf(ptr %format_ptr, i32 1)

        %newline_ptr = getelementptr [2 x i8], ptr @.str_newline, i32 0, i32 0
        call i32 (ptr, ...) @printf(ptr %newline_ptr) 
        ret i1 %check

    notEmpty:
        %format_ptr2 = getelementptr [4 x i8], ptr @.str_num, i32 0, i32 0
        call i32 (ptr, ...) @printf(ptr %format_ptr2, i32 0)

        %newline_ptr2 = getelementptr [2 x i8], ptr @.str_newline, i32 0, i32 0
        call i32 (ptr, ...) @printf(ptr %newline_ptr2) 

        ret i1 %check
}

define void @printTop(ptr %Ptr) {
    %head = load ptr, ptr %Ptr
    %cond = icmp eq ptr %head, null
    br i1 %cond, label %empty, label %notEmpty

notEmpty:
    %topelement = getelementptr %Stack, ptr %head, i32 0, i32 0
    %topVal = load i32, ptr %topelement

    %format_ptr = getelementptr [4 x i8], ptr @.str_num, i32 0, i32 0
    call i32 (ptr, ...) @printf(ptr %format_ptr, i32 %topVal)

    %newline_ptr = getelementptr [2 x i8], ptr @.str_newline, i32 0, i32 0
    call i32 (ptr, ...) @printf(ptr %newline_ptr) 
    ret void

empty:

    ret void
}

define void @pop(ptr %Ptr) {
    %head = load ptr, ptr %Ptr
    %cond = icmp eq ptr %head, null
    br i1 %cond, label %empty, label %notEmpty

notEmpty:
    %nextPtr = getelementptr %Stack, ptr %head, i32 0, i32 1
    %newHead = load ptr, ptr %nextPtr
    store ptr %newHead, ptr %Ptr

    call void @free(ptr %head)
    ret void

empty:
    ret void
}

define i32 @main() {
    %headptr = alloca ptr, align 8
    store ptr null, ptr %headptr

    call void @push(i32 1, ptr %headptr)
    call void @push(i32 2, ptr %headptr)
    call void @push(i32 3, ptr %headptr)

    call void @printTop(ptr %headptr)

    call void @pop(ptr %headptr)
    call void @printTop(ptr %headptr)

    call void @pop(ptr %headptr)
    call void @printTop(ptr %headptr)
    call void @pop(ptr %headptr)
    %isEmpty = call i1 @is_empty(ptr %headptr)



    ret i32 0
    
}
