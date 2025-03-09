
%Node = type {i32 ,ptr ,ptr }


; Logic for Printing later i will create a seprate file for this 

@.str = private constant [4 x i8] c"%d\0A\00"
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

        %format_ptr = getelementptr [4 x i8], ptr @.str, i32 0, i32 0
        call i32 (ptr, ...) @printf(ptr %format_ptr, i32 %val) 

        %next_ptr = getelementptr %Node,ptr %ptr_val,i32 0,i32 2
        %prev= load ptr,ptr %next_ptr
        store ptr %prev,ptr %current
        br label %loop

    end:
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


define i32 @main(){

    %headPtr = alloca ptr , align 8
    store ptr null,ptr %headPtr

    call void @add(i32 10,ptr %headPtr)
    call void @add(i32 20,ptr %headPtr) 
    call void @add(i32 90,ptr %headPtr)

  
    call void @print(ptr %headPtr)

    call void @delete(ptr %headPtr)
   
    call void @print(ptr %headPtr)
    ret i32 0

}


