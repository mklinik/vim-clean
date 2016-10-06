syntax keyword abcKeyword     .comp .code .start .depend .endinfo .module .implab .impdesc .impmod .record .export
syntax match   abcLabel       "\v^[a-zA-Z0-9_\.]+\s*$"
syntax region  abcNote        start=/\v\.(a|d|o|n|nu|keep|pb|pe)( |$)/ end=/\n/ oneline
syntax region  abcComment     start=/|/ end=/\n/ oneline

syntax match   abcInteger     "\v(-|<)\d+>"
syntax match   abcReal        "\v<\d+\.\d+>"
syntax match   abcSpecialChar contained "\\\([0-9]\+\|o[0-7]\+\|x[0-9a-fA-F]\+\|[\"\\'&abfnrtv]\)" transparent
syntax match   abcChar        "'\\\([0-9]\+\|o[0-7]\+\|x[0-9a-fA-F]\+\|[\"\\'&abfnrtv]\)'" display
syntax match   abcChar        "'.'" display
syntax region  abcString      start=+"+ skip=+\\\\\|\\"+ end=+"+ oneline contains=abcSpecialChar
syntax keyword abcBool        TRUE FALSE
syntax keyword abcConstant    ARRAY INT

syntax match   abcDescLabel   /\v\h[a-zA-Z0-9_\.]*/ contained
syntax match   abcDescKeyword /\v\.desc(s|n|exp)? / contained
syntax match   abcDescriptor  /\v\.desc(s|n|exp)? .*$/ contains=abcDescKeyword,abcDescLabel,abcInteger,abcString

syntax keyword abcInstruction
			\ add_args del_args
			\ dump print print_sc print_symbol_sc
			\ print_int print_char print_real printD
			\ eq_desc eq_desc_b eq_desc_arity eq_symbol eq_nulldesc
			\ eqB eqB_a eqB_b eqI eqI_a eqI_b eqC_b
			\ is_record
			\ create create_array_
			\ fill fillh fill_a fill_r fillI_b fillR_b fill1 fill2
			\ build buildh build_r build_u buildAC buildB buildC buildI buildR
			\ get_desc_arity get_node_arity
			\ halt no_op setwait suspend release getWL
			\ jmp jmp_ap jmp_eval jmp_eval_upd jmp_false jmp_true
			\ jsr jsr_ap jsr_eval rtn
			\ pop_a pop_b
			\ push_a push_b pushB pushB_a pushI pushI_a
			\ push_node push_node_u
			\ push_ap_entry push_array push_arraysize
			\ push_arg push_arg_b push_args push_args_b push_args_u
			\ push_a_r_args push_r_args_b push_r_arg_t push_t_r_a push_t_r_args
			\ pushA_a pushD_a
			\ repl_arg repl_args repl_args_b repl_r_args_a select
			\ set_entry update update_a update_b updatepop_a updatepop_b
			\ addI decI gtI incI ltI subI mulI
			\ and%

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
