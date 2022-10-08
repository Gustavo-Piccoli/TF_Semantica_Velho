  

  
    (*  o programa abaixo retorna
        valor   = 7 
        memória = [(l1, 4)] 
    
    let x : int ref = new 3 in  -- x = end 1; 
    let y : int = !x in  --  y = 3
        (x := !x + 1);   -- 
        y + !x
*)
   
   
let teste1 = Let("x", TyRef TyInt, New (Num 3),
                 Let("y", TyInt, Dref (Var "x"), 
                     Seq(Asg(Var "x", Binop(Sum, Dref(Var "x"), Num 1)), 
                         Binop(Sum, Var "y",  Dref (Var "x"))))) 
     
   
    (*
        o programa abaixo retorna
        valor   = 1 
        memória = [(l1, 1)] 

     let x: int ref  = new 0 in
     let y: int ref  = x in
        x := 1;
        !y
    *)
    
    
let teste2 = Let("x", TyRef TyInt, New (Num 0),
                 Let("y", TyRef TyInt, Var "x", 
                     Seq(Asg(Var "x", Num 1), 
                         Dref (Var "y"))))
    
    
    (*  o programa abaixo retorna
        valor   = 3
        memória = [(l1, 2)]
    

      let counter : int ref = new 0  in 
      let next_val : unit -> int =
         fn ():unit  =>
            counter := (!counter) + 1;
           !counter
      in  (next_val()  + next_val())  
*)
    
    
let counter1 = Let("counter", TyRef TyInt, New (Num 0),
                   Let("next_val", TyFn(TyUnit, TyInt),
                       Fn("w", TyUnit, 
                          Seq(Asg(Var "counter",Binop(Sum, Dref(Var "counter"), Num 1)),
                              Dref (Var "counter"))),
                       Binop(Sum, App (Var "next_val", Skip), 
                             App (Var "next_val", Skip))))
    
  
    

    (*   o programa abaixo retorna
     valor = 120
     memória = [(l2, 120), (l1,0) ]
     

    let fat (x:int) : int = 

        let z : int ref = new x in
        let y : int ref = new 1 in 
        
        while (!z > 0) (
           y :=  !y * !z;
           z :=  !z - 1;
        );
        ! y
    in
       fat 5
       
       
       
    SEM açucar sintático
    
    let fat : int-->int = fn x:int => 

        let z : int ref = new x in
        let y : int ref = new 1 in 
        
        while (!z > 0) (
           y :=  !y * !z;
           z :=  !z - 1;
        );
        ! y
    in
       fat 5
       
       
*) 
    
let whilefat = Whl(Binop(Gt, Dref (Var "z"), Num 0), 
                   Seq( Asg(Var "y", Binop(Mult, Dref (Var "y"), Dref (Var "z"))), 
                        Asg(Var "z", Binop(Sub, Dref (Var "z"), Num 1)))                       
                  ) 
                               
                             
let bodyfat = Let("z", TyRef TyInt, New (Var "x"),
                  Let("y", TyRef TyInt, New (Num 1), Seq (whilefat, Dref (Var "y"))))
    
let impfat = Let("fat", TyFn(TyInt,TyInt), Fn("x", TyInt, bodyfat), App(Var "fat", Num 5))
       
  

                         