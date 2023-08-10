@@
expression vma, set;
@@
- vma->vm_flags |= set
+ vm_flags_set(vma, set)

@@
expression vma, clear;
@@
- vma->vm_flags &= ~clear
+ vm_flags_clear(vma, clear)
