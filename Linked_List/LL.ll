
%Node = type {i32 ,ptr ,ptr }


; Logic for Printing later i will create a seprate file for this 

@.str_num = private constant [4 x i8] c"%d \00"
@.str_newline = private constant [2 x i8] c"\0A\00"
declare i32 @printf(ptr, ...)
declare ptr @malloc(i32)
declare void @free(ptr)



define void @print(ptr %headptr){

    entry:
        %head= load ptr, ptr %headptr
        %current = alloca ptr
        store ptr %head, ptr %current
        br label %loop

    loop:
        %ptr_val= load ptr , ptr %current
        %is_null= icmp eq ptr %ptr_val,null
        br i1 %is_null , label %end , label %trav

    trav:
        %val_ptr= getelementptr %Node,ptr %ptr_val,i32 0,i32 0
        %val= load i32,ptr %val_ptr

        %format_ptr = getelementptr [4 x i8], ptr @.str_num, i32 0, i32 0
        call i32 (ptr, ...) @printf(ptr %format_ptr, i32 %val) 

        %next_ptr = getelementptr %Node,ptr %ptr_val,i32 0,i32 2
        %prev= load ptr,ptr %next_ptr
        store ptr %prev,ptr %current
        br label %loop

    end:
        %newline_ptr = getelementptr [2 x i8], ptr @.str_newline, i32 0, i32 0
        call i32 (ptr, ...) @printf(ptr %newline_ptr) 
        ret void

}

define void @printStart(ptr %headptr){

    entry:
        %head= load ptr, ptr %headptr
        %current = alloca ptr
        store ptr %head, ptr %current
        br label %loop

    loop:
        %ptr_val= load ptr , ptr %current
        %is_null= icmp eq ptr %ptr_val,null
        br i1 %is_null , label %end , label %trav

    trav:
        %val_ptr= getelementptr %Node,ptr %ptr_val,i32 0,i32 0
        %val= load i32,ptr %val_ptr

        %format_ptr = getelementptr [4 x i8], ptr @.str_num, i32 0, i32 0
        call i32 (ptr, ...) @printf(ptr %format_ptr, i32 %val) 

        %next_ptr = getelementptr %Node,ptr %ptr_val,i32 0,i32 1
        %prev= load ptr,ptr %next_ptr
        store ptr %prev,ptr %current
        br label %loop

    end:
        %newline_ptr = getelementptr [2 x i8], ptr @.str_newline, i32 0, i32 0
        call i32 (ptr, ...) @printf(ptr %newline_ptr) 
        ret void

}


define void @add(i32 %val , ptr %headPtr ){
    %head= load ptr,ptr %headPtr

    %size= getelementptr %Node, ptr null, i32 1
    %bytes= ptrtoint ptr %size to i32
    %newNode= call ptr @malloc(i32 %bytes) 
    
    %valStore= getelementptr %Node,ptr %newNode, i32 0,i32 0
    store i32 %val,ptr %valStore

    %forwardPointer= getelementptr %Node,ptr %newNode, i32 0,i32 1
    store ptr null,ptr %forwardPointer

    %previousPointer= getelementptr %Node, ptr %newNode, i32 0,i32 2
    store ptr %head, ptr %previousPointer

    %isNUll= icmp eq ptr %head, null

    br i1 %isNUll, label %Uhead, label %Mhead

Mhead:
    %prevNext= getelementptr %Node,ptr %head, i32 0, i32 1
    store ptr %newNode, ptr %prevNext
    
    br label %Uhead

Uhead:

    store ptr %newNode, ptr %headPtr
    ret void     

}

define void @addFront(i32 %val , ptr %startPtr){
    %head= load ptr,ptr %startPtr

    %size= getelementptr %Node, ptr null, i32 1
    %bytes= ptrtoint ptr %size to i32
    %newNode= call ptr @malloc(i32 %bytes) 
    
    %valStore= getelementptr %Node,ptr %newNode, i32 0,i32 0
    store i32 %val,ptr %valStore

    %forwardPointer= getelementptr %Node,ptr %newNode, i32 0,i32 1
    store ptr %head,ptr %forwardPointer

    %previousPointer= getelementptr %Node, ptr %newNode, i32 0,i32 2
    store ptr null, ptr %previousPointer

    %isNUll= icmp eq ptr %head, null

    br i1 %isNUll, label %Uhead, label %Mhead

Mhead:
    %prevNext= getelementptr %Node,ptr %head, i32 0, i32 2
    store ptr %newNode, ptr %prevNext

    br label %Uhead

Uhead:

    store ptr %newNode, ptr %startPtr
    ret void     

}


define void @delete(ptr %headPtr){

    %head= load ptr,ptr %headPtr

    %flag=icmp eq ptr %head,null
    br i1 %flag, label %end, label %delete_node

delete_node:
    
    %next= getelementptr %Node,ptr %head , i32 0, i32 2
    %prev = load ptr, ptr %next 
    store ptr %prev ,ptr %headPtr

    call void @free(ptr %head)
    br label %end

end:
    
    ret void

}

define void @deleteFront(ptr %startPtr){

    %head= load ptr,ptr %startPtr

    %flag=icmp eq ptr %head,null
    br i1 %flag, label %end, label %delete_node

delete_node:
    
    %next= getelementptr %Node,ptr %head , i32 0, i32 1
    %nextN = load ptr, ptr %next

    %prev=getelementptr %Node,ptr %nextN ,i32 0, i32 2
    store ptr null,ptr %prev

    store ptr %nextN ,ptr %startPtr

    
    call void @free(ptr %head)
    br label %end

end:
    
    ret void

}


define i32 @main(){

    %headPtr = alloca ptr , align 8
    %startPtr = alloca ptr , align 8

    store ptr null,ptr %headPtr
    call void @add(i32 10,ptr %headPtr)


    %firstNode= load ptr,ptr %headPtr
    store ptr %firstNode,ptr %startPtr


    call void @add(i32 20,ptr %headPtr) 
    call void @add(i32 90,ptr %headPtr)
    call void @addFront(i32 30,ptr %startPtr)

    call void @add(i32 90,ptr %headPtr)
    call void @add(i32 90,ptr %headPtr)
  
    call void @printStart(ptr %startPtr)
    call void @addFront(i32 30,ptr %startPtr)

    call void @printStart(ptr %startPtr)


    call void @deleteFront(ptr %startPtr)

    call void @print(ptr %headPtr)
    


    ret i32 0

}


