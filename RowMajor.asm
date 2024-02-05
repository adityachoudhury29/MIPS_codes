 .data
data:    .word     0 : 256       
         .text
         li       $t0, 16        
         li       $t1, 16       
         move     $s0, $zero     
         move     $s1, $zero     
         move     $t2, $zero    

loop:    mult     $s0, $t1       
         mflo     $s2            
         add      $s2, $s2, $s1  
         sll      $s2, $s2, 2    
         sw       $t2, data($s2) 
         addi     $t2, $t2, 1    

         addi     $s1, $s1, 1    
         bne      $s1, $t1, loop 
         move     $s1, $zero    
         addi     $s0, $s0, 1    
         bne      $s0, $t0, loop 

         li       $v0, 10       
         syscall                
