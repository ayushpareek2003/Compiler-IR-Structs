%Node = type {i32 ,ptr %Node ,ptr %Node}


; Logic for Printing later i will create a seprate file for this 

@.str=private constant [4*i8] c"%d\0A\00"
declear i32 @printf(ptr, ...)


define void @print(ptr %head){

    entry:
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

        %next_ptr = getelementptr %Node,ptr %ptr_val,i32 0,i32 1
        %next= load ptr,ptr %next_ptr
        store ptr %next,ptr %current
        br label %loop

    end:
        ret void

}


define void @add(i32){
    

}

define void @delete(){

}


define i32 @main(){
    %head = alloca %Node
    %val= getelementptr %Node, ptr %head ,i32 0,i32 0

    store i32 100,ptr %val

    ret i32 0

}


