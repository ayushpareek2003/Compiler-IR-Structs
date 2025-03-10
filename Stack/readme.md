# Stack Implementation

This Folder contains an implementation of a **stack** using **LLVM Intermediate Representation (LLVM IR)**

## Usage

The following LLVM IR commands demonstrate how to use the stack:

### 1 Initialize the Stack
```llvm
%headptr = alloca ptr, align 8
store ptr null, ptr %headptr
```
This allocates space for the stack pointer and initializes it to `null`

### 2 Push Elements onto the Stack
```llvm
call void @push(i32 1, ptr %headptr)
call void @push(i32 2, ptr %headptr)
call void @push(i32 3, ptr %headptr)
```
Pushes the values `1`, `2`, and `3` onto the stack in sequence

### 3 Print the Top Element
```llvm
call void @printTop(ptr %headptr)
```
Prints the topmost element of the stack

### 4 Pop Elements from the Stack
```llvm
call void @pop(ptr %headptr)
call void @printTop(ptr %headptr)
```
Removes the topmost element and prints the new top element

### 5 Continue Popping Until Stack is Empty
```llvm
call void @pop(ptr %headptr)
call void @printTop(ptr %headptr)
call void @pop(ptr %headptr)
%isEmpty = call i1 @is_empty(ptr %headptr)
```
This sequence pops all elements and checks whether the stack is empty

## Functions Implemented

- `@push(i32, ptr)`: Pushes an integer onto the stack
- `@pop(ptr)`: Removes the top element from the stack
- `@printTop(ptr)`: Prints the top element of the stack
- `@is_empty(ptr) -> i1`: Returns `true` (`1`) if the stack is empty, otherwise `false` (`0`)

## How the Stack Works
- The stack follows **Last In, First Out (LIFO)** order
- Each node in the stack contains a value and a pointer to the previous top element
- The `headptr` always points to the topmost node
- Popping removes the top element and updates `headptr` to the next node


