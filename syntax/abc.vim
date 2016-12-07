if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syntax match   abcQuietLabel  /\v\h[a-zA-Z0-9_\.;<>\\`=+|&~^\/*%!:-]*/
syntax match   abcInteger     "\v(-|<)\d+>"
syntax match   abcReal        "\v<\d+\.\d+>"

syntax keyword abcKeyword     .code .comp .depend .endinfo .implib .impmod .module .record
syntax match   abcLabel       "\v^[a-zA-Z0-9_\.;<>\\`=+|&~^\/*%!:-]+\s*$"
syntax region  abcNote        start=/\v\.(a|d|o|n|nu|end|keep|pb|pd|pe|pld|pn|inline|string)( |$)/ end=/\n/ oneline
syntax region  abcComment     start=/\v(^|\s)\|/ end=/\n/ oneline

syntax match   abcSpecialChar "\\\([0-9]\+\|o[0-7]\+\|x[0-9a-fA-F]\+\|[\"\\'&abfnrtv]\)" contained transparent
syntax match   abcChar        "'\\\([0-9]\+\|o[0-7]\+\|x[0-9a-fA-F]\+\|[\"\\'&abfnrtv]\)'" display
syntax match   abcChar        "'.'" display
syntax region  abcString      start=+"+ skip=+\\\\\|\\"+ end=+"+ oneline contains=abcSpecialChar
syntax keyword abcConstant
			\ ARRAY BOOL CHAR EMPTY FILE dINT INT INT32 REAL REAL32 _STRING_ _ARRAY_
syntax keyword abcConstant
			\ _Cons _Consa _Consb _Consc _Consf _Consi _Consr _Conss
			\ _Consbts _Conscts _Consfts _Consits _Consrts _Conssts
			\ _Nil _Nila _Nilb _Nilc _Nilf _Nili _Nilr _Nils
			\ _Nilbts _Nilcts _Nilfts _Nilits _Nilrts _Nilsts
			\ _Tuple
			\ FALSE TRUE

syntax match   abcDescLabel   /\v\h[a-zA-Z0-9_\.;<>\\`=+|&~^\/*%!:-]*/ contained
syntax match   abcDescKeyword /\v\.(start|export|imp(lab|desc)|desc(0|s|n|exp)?)\s/ contained
syntax match   abcDescriptor  /\v\.(start|export|imp(lab|desc)|desc(0|s|n|exp)?)\s.*$/
			\ contains=abcDescKeyword,abcDescLabel,abcInteger,abcString

syntax keyword abcInstruction
			\ add_args del_args
			\ dump print print_sc print_symbol_sc
			\ print_int print_char print_real printD
			\ eq_desc eq_desc_b eq_desc_arity eq_symbol eq_nulldesc
			\ eqB eqB_a eqB_b eqI eqI_a eqI_b eqC_b
			\ is_record
			\ create create_array create_array_
			\ fill fillh fill_a fill_r fill1 fill2
			\ fillB_b fillC_b fillF_b fillI_b fillR_b
			\ build buildh build_r build_u buildAC buildB buildC buildI buildR
			\ buildB_b buildC_b buildF_b buildI_b buildR_b
			\ get_desc_arity get_node_arity
			\ halt no_op setwait suspend release getWL exit_false
			\ jmp jmp_ap jmp_eval jmp_eval_upd jmp_false jmp_true
			\ jsr jsr_ap jsr_eval rtn
			\ pop_a pop_b
			\ push_a push_b pushB pushB_a pushC pushC_a pushI pushI_a
			\ push_node push_node_u
			\ push_ap_entry push_array push_arraysize
			\ push_arg push_arg_b push_args push_args_b push_args_u
			\ push_a_r_args push_r_args push_r_args_a push_r_args_b
			\ push_r_arg_t push_t_r_a push_t_r_args push_r_arg_D
			\ pushA_a pushD pushD_a pushF_a pushR_a pushR pushC_a
			\ repl_arg repl_args repl_args_b repl_r_args repl_r_args_a replace
			\ select set_entry update update_a update_b updatepop_a updatepop_b
			\ ccall stdcall centry
			\ CtoAC CtoI ItoC ItoR RtoI
			\ addI decI divI gtI incI ltI mulI negI remI subI
			\ notB
			\ eqD_b
			\ absR addR divR eqR expR ltR mulR negR powR sqrtR subR
			\ acosR atanR cosR entierR log10R lnR sinR tanR
			\ eqC gtC ltC
			\ and% not% or% shiftl% shiftr% xor%

highlight default link abcInstruction Statement
highlight default link abcKeyword     Keyword
highlight default link abcLabel       Identifier
highlight default link abcNote        SpecialComment
highlight default link abcComment     Comment
highlight default link abcDescriptor  Keyword
highlight default link abcDescLabel   Identifier
highlight default link abcDescKeyword Keyword

highlight default link abcInteger     Number
highlight default link abcReal        Float
highlight default link abcString      String
highlight default link abcChar        Character
highlight default link abcBool        Boolean
highlight default link abcConstant    Constant

let b:current_syntax = 'abc'

let &cpo = s:cpo_save
unlet s:cpo_save
