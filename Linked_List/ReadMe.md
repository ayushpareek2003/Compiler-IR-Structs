# LLVM Linked List Implementation

## Cloning the Repository

```sh
git clone https://github.com/ayushpareek2003/Compiler-IR-Structs.git
cd Compiler-IR-Structs
cd Linked_List
```

## Defining Pointers

```llvm
%headPtr = alloca ptr , align 8
%startPtr = alloca ptr , align 8
store ptr null, ptr %headPtr
```

## Adding Nodes

```llvm
call void @add(i32 10, ptr %headPtr)
call void @add(i32 20, ptr %headPtr)
call void @add(i32 90, ptr %headPtr)
```

## Adding to the Front

```llvm
%firstNode = load ptr, ptr %headPtr
store ptr %firstNode, ptr %startPtr
call void @addFront(i32 30, ptr %startPtr)
```

## Printing the Linked List

```llvm
call void @printStart(ptr %startPtr)
call void @print(ptr %headPtr)
```

## Deleting from the Front

```llvm
call void @deleteFront(ptr %startPtr)
```

## Running the Code

```sh
llvm-as LL.ll -o linkedlist.bc
lli linkedlist.bc
```
