" ABC syntax file
" Language:     ABC
" Author:       Camil Staps <info@camilstaps.nl>
" License:      This file is placed in the public domain.
"
if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syntax match   abcQuietLabel  /\v\h[a-zA-Z0-9_\.;<>\\`=+|&~^\/*%!:-]*/
syntax match   abcInteger     "\v(-|<)\d+>"
syntax match   abcReal        "\v<\d+\.\d+>"

syntax keyword abcKeyword
			\ .algtype .code .comp .depend .end .endinfo .implib .impobj
			\ .module .record .string
syntax match   abcLabel       "\v^[a-zA-Z0-9_\.;<>\\`=+|&~^\/*%!:-]+\s*$"
syntax region  abcNote        start=/\v\.(a|caf|d|o|n|nu|end|keep|pb|pd|pe|pld|pn|inline|string)( |$)/ end=/\n/ oneline
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
syntax match   abcDescKeyword /\v\.(start|export|imp(lab|mod|desc)|desc(0|s|n|exp)?)\s/ contained
syntax match   abcDescriptor  /\v\.(start|export|imp(lab|mod|desc)|desc(0|s|n|exp)?)\s.*$/
			\ contains=abcDescKeyword,abcDescLabel,abcInteger,abcString

syntax keyword abcInstruction
			\ absR acosR add_args addI addIo addLU addR andB and% asinR atanR
			\ build buildB buildC buildI buildR buildAC buildB_b buildC_b
			\ buildF_b buildI_b buildR_b buildh build_r build_u
			\ catS call ccall centry cmpS ceilingR CtoAC copy_graph cosR
			\ code_channelP create create_array create_array_ create_channel
			\ currentP CtoI
			\ decI del_args divI divLU divR divU
			\ entierR eqB eqB_a eqB_b eqC eqC_a eqC_b eqD_b eqI eqI_a eqI_b eqR
			\ eqR_a eqR_b eqAC_a eq_desc eq_desc_b eq_nulldesc eq_symbol
			\ exit_false expR
			\ fill fill1 fill2 fill3 fill1_r fill2_r fill3_r fillcaf fillcp
			\ fillcp_u fill_u fillh fillB fillB_b fillC fillC_b fillF_b fillI
			\ fillI_b fillR fillR_b fill_a fill_r floordivI
			\ getWL get_desc_arity get_desc_flags_b get_desc0_number
			\ get_node_arity gtC gtI gtR gtU
			\ halt
			\ in incI instruction is_record ItoC ItoP ItoR
			\ jmp jmp_ap jmp_ap_upd jmp_upd jmp_eval jmp_eval_upd jmp_false
			\ jmp_not_eqZ jmp_true jrsr jsr jsr_ap jsr_eval
			\ lnR load_i load_si16 load_si32 load_ui8 log10R ltC ltI ltR ltU
			\ modI mulI mulIo mulR mulUUL
			\ negI negR new_ext_reducer new_int_reducer newP no_op notB not%
			\ orB or% out
			\ pop_a pop_b powR print printD print_char print_int print_real
			\ print_r_arg print_sc print_symbol print_symbol_sc pushcaf
			\ push_finalizers pushA_a pushB pushB_a pushC pushC_a pushD pushD_a
			\ pushF_a pushI pushI_a pushL pushLc pushR pushR_a pushzs push_a
			\ push_b push_a_b push_arg push_arg_b push_args push_args_u
			\ push_array push_arraysize push_b_a push_node push_node_u
			\ push_a_r_args push_t_r_a push_t_r_args push_r_args push_r_args_a
			\ push_r_args_b push_r_args_u push_r_arg_D push_r_arg_t
			\ push_r_arg_u push_wl_args pushZ pushZR putWL
			\ randomP release remI remU replace repl_arg repl_args repl_args_b
			\ repl_r_args repl_r_args_a rotl% rotr% rtn RtoI
			\ select send_graph send_request set_continue set_defer set_entry
			\ set_finalizers setwait shiftl% shiftr% shiftrU sinR sincosR
			\ sliceS sqrtR stop_reducer subI subIo subLU subR suspend
			\ tanR testcaf truncateR
			\ update_a updatepop_a update_b updatepop_b updateS update
			\ xor%

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
