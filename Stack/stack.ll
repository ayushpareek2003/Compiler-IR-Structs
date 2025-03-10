
%Stack = type {i32 , i32, ptr}

@.str_num = private constant [4 x i8] c"%d \00"
@.str_newline = private constant [2 x i8] c"\0A\00"
declare i32 @printf(ptr, ...)
declare ptr @malloc(i32)
declare void @free(ptr)


define void @push(i32 %data, ptr %Ptr){
    entry:
        %head= load ptr,ptr %Ptr
        %sizePointer= getelementptr %Stack, ptr %head, i32 0, i32 1
        %size= load i32, ptr %sizePointer

        %sizeT= getelementptr %Stack, ptr null, i32 1
        %bytes= ptrtoint ptr %sizeT to i32
        %newNode= call ptr @malloc(i32 %bytes) 

        %valStore= getelementptr %Stack,ptr %newNode, i32 0,i32 0
        store i32 %data,ptr  %valStore

        %newSizePointer= getelementptr %Stack, ptr %newNode, i32 0,i32 1
        %newSize= add i32 %size,1
        store i32 %newSize,ptr %newSizePointer

        %cond= icmp eq i32 %size, 0
        br i1 %cond, label %Uhead, label %Mhead


    Mhead:
        %prevNext= getelementptr %Stack,ptr %newNode, i32 0, i32 2
        store ptr %head, ptr %prevNext
        br label %Uhead

    Uhead:
        store ptr %newNode, ptr %Ptr
        ret void
}


define i32 @size(ptr %Ptr){
    %head=load ptr,ptr %Ptr

    %sizePointer= getelementptr %Stack, ptr %head, i32 0, i32 1
    %size= load i32, ptr %sizePointer

    ret i32 %size
}

define i32 @top(ptr %Ptr){
    %head=load ptr,ptr %Ptr

    %cond=icmp eq ptr %head,null
    br i1 %cond,label %empty,label %notEmpty

    notEmpty:
        %top= getelementptr %Stack,ptr %head, i32 0, i32 0
        %topVal= load i32,ptr %top
        ret i32 %topVal
    empty:
        ret i32 -1    
}

define void @pop(ptr %Ptr){
    %head=load ptr,ptr %Ptr

    %cond=icmp eq ptr %head,null
    br i1 %cond,label %empty,label %notEmpty

    notEmpty:
        %newHead= getelementptr %Stack,ptr %head, i32 0, i32 2
        %newHEAD= load ptr,ptr %newHead
        store ptr %newHEAD,ptr %Ptr

        call void @free(ptr %head)
        ret void

    empty:
        ret void


}

define i1 @is_empty(ptr %Ptr){
    %head=load ptr,ptr %Ptr

    %check=icmp eq ptr %head,null
    br i1 %check,label %empty,label %notEmpty

    empty:
        ret i1 true
    notEmpty:
        ret i2 false


}

define void @printTop(ptr %Ptr){
    %head= load ptr,ptr %Ptr

    %cond=icmp eq ptr %head,null
    br i1 %cond,label %empty,label %notEmpty

    notEmpty:

        %topelement= getelementptr %Stack,ptr %head, i32 0, i32 0
        %topVal= load i32,ptr %topelement

        %format_ptr = getelementptr [4 x i8], ptr @.str_num, i32 0, i32 0
        call i32 (ptr, ...) @printf(ptr %format_ptr, i32 %topVal)

        br label %empty
    
    empty:
        ret void

}

define i32 @main(){

    %headptr=alloca ptr,align 8

    store ptr null, ptr %headptr

    call void @push(i32 1,ptr %headptr)
    call void @push(i32 2,ptr %headptr)
    call void @push(i32 3,ptr %headptr)

    call void @printTop(ptr %headptr)

    ret i32 0


}


