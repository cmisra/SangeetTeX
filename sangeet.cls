\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{sangeet}[2020/07/10 Sangeet LaTeX class]
\LoadClass{article}
\RequirePackage[margin=0.7in]{geometry}
\RequirePackage{fontspec}
\RequirePackage{tikz}
\usetikzlibrary{positioning, fit}
\RequirePackage{ifthen}
\RequirePackage{etoolbox}
\RequirePackage{expl3}

%-----remove date and author-----%
\newcommand{\name}[1]{
    \title{#1}
    \date{}
    \author{}
}

%-----make the title-----%
\newcommand{\makename}{
    \maketitle
}

\setmonofont{Bangla}[
    Path=./BanglaFontFiles/,
    Extension = .ttf,
    ]
    
%-----set swarabitan font-----%
\setsansfont{Swarabitan}[
    Path=./Swarabitan/,
    Scale=0.85,
    Extension = .ttf,
    ]

\ExplSyntaxOn
%-----sangeet environment to write a composition-----%
\newenvironment{sangeet}% environment name
{
    \clist_new:N \c_dadra_pattern_clist
    \clist_new:N \c_jhap_pattern_clist
    \clist_new:N \c_iktaal_pattern_clist
    \clist_new:N \c_dhamaar_pattern_clist
    \clist_new:N \c_teentaal_pattern_clist
    \clist_new:N \c_kaharba_pattern_clist
    \clist_new:N \c_shashthi_pattern_clist
    \clist_new:N \c_teora_pattern_clist
    \clist_new:N \c_jhampak_pattern_clist
    
    
    \clist_set:Nn \c_dadra_pattern_clist { 3,3 }
    \clist_set:Nn \c_jhap_pattern_clist { 2,3 }
    \clist_set:Nn \c_iktaal_pattern_clist { 3,3,3,3 }
    \clist_set:Nn \c_dhamaar_pattern_clist { 3,2,2,3,4 }
    \clist_set:Nn \c_teentaal_pattern_clist { 4,4,4,4 }
    \clist_set:Nn \c_kaharba_pattern_clist { 4,4 }
    \clist_set:Nn \c_shashthi_pattern_clist { 2,4 }
    \clist_set:Nn \c_teora_pattern_clist { 3,2,2 }
    \clist_set:Nn \c_jhampak_pattern_clist { 3,2 }
    
    \int_new:N \c_dadra_maatra_int
    \int_new:N \c_jhap_maatra_int
    \int_new:N \c_iktaal_maatra_int
    \int_new:N \c_dhamaar_maatra_int
    \int_new:N \c_teentaal_maatra_int
    \int_new:N \c_kaharba_maatra_int
    \int_new:N \c_shashthi_maatra_int
    \int_new:N \c_teora_maatra_int
    \int_new:N \c_jhampak_maatra_int
    
    \int_set:Nn \c_dadra_maatra_int { \clist_count:N \c_dadra_pattern_clist }
    \int_set:Nn \c_jhap_maatra_int { \clist_count:N \c_jhap_pattern_clist }
    \int_set:Nn \c_iktaal_maatra_int { \clist_count:N \c_iktaal_pattern_clist }
    \int_set:Nn \c_dhamaar_maatra_int { \clist_count:N \c_dhamaar_pattern_clist }
    \int_set:Nn \c_teentaal_maatra_int { \clist_count:N \c_teentaal_pattern_clist }
    \int_set:Nn \c_kaharba_maatra_int { \clist_count:N \c_kaharba_pattern_clist }
    \int_set:Nn \c_shashthi_maatra_int { \clist_count:N \c_shashthi_pattern_clist }
    \int_set:Nn \c_teora_maatra_int { \clist_count:N \c_teora_pattern_clist }
    \int_set:Nn \c_jhampak_maatra_int { \clist_count:N \c_jhampak_pattern_clist }
    
    \int_new:N \l_number_cells_int % Number of cells required to render the line
    \int_new:N \l_maatra_int % Number of measures in the input Taal
    \int_new:N \l_avartan_int % Number of input avartan
    \clist_new:N \l_beat_pattern_clist % Beat pattern of the input Taal
    \int_new:N \l_temp_int
    \str_new:N \l_taal_str
    \seq_new:N \l_start_seq
    \int_new:N \l_taal_bibhaga_int
    \seq_new:N \l_taal_bibhag_seq
    \int_new:N \l_i_int
    \seq_new:N \l_cum_taal_seq
    \int_new:N \l_sum_int
    \seq_new:N \l_taal_seq
    \seq_new:N \l_svar_index_seq
    \clist_new:N \l_svar_clist
    \clist_new:N \l_svar_modified_clist
    \seq_new:N \l_meend_index_seq
    \int_new:N \l_seq_int
    \int_new:N \l_meend_true_int
    \clist_new:N \l_pattern_list_clist
    \int_new:N \l_index_int
    \clist_new:N \l_pattern_cumul_clist
    \int_new:N \l_par_sum_int
    \seq_new:N \l_serial_seq
    \int_new:N \l_serial_count_int
    \seq_new:N \l_pattern_cumul_seq
    \seq_new:N \l_meend_final_seq
    \seq_new:N \l_svar_modified_seq
    \seq_new:N \l_svar_seq
    \int_new:N \l_beat_count_int % Total number beat count in the input Taal
    \seq_new:N \l_cell_list_seq
}
\ExplSyntaxOff

\ExplSyntaxOn
%-----command \scoreline to compose a single line of a score (except the first or last phrase)-----%
\ExplSyntaxOn
%-----command \scoreline to compose a single line of a score (except the first or last phrase)-----%
\newcommand{\scoreline}[3]{

    \int_set:Nn \l_number_cells_int { 0 } % represents no cell present at first
    
    \str_set:Nn \l_taal_str { #1 } % sets the name of Taal

    \int_set:Nn \l_maatra_int { \cs:w c _\str_use:N \l_taal_str _maatra _int \cs_end: }
    \clist_set:Nx \l_beat_pattern_clist { \cs:w c _\str_use:N \l_taal_str _pattern _clist \cs_end: }
    
    \int_set:Nn \l_beat_count_int { 0 }
    \clist_map_variable:NNn \l_beat_pattern_clist \l_tmpa_int {
        \int_add:Nn \l_beat_count_int { \l_tmpa_int }
    }
    
    \int_set:Nn \l_avartan_int { #2 }

    \int_set:Nn \l_number_cells_int {  \int_eval:n {(\l_avartan_int * (\l_maatra_int - 1)) + (\l_beat_count_int * \l_avartan_int) + (\l_avartan_int - 1) + 2} }

    
    \int_step_variable:nNn {\l_number_cells_int} {\l_start_tl} {
        \seq_put_right:Nx \l_cell_list_seq {\l_start_tl}
    }
    
    % \seq_use:Nn \l_cell_list_seq { , }
    
    
    \if_int_compare:w \l_avartan_int = 1
        \seq_put_right:Nx \l_start_seq { 1 }
        \seq_put_right:Nx \l_start_seq { \seq_count:N \l_cell_list_seq }    
    \else:
        \seq_put_right:Nx \l_start_seq { 1 }
        \int_set:Nn \l_temp_int { 1 }
        \int_step_variable:nNn { \int_eval:n { (\l_avartan_int - 1) } } {\l_start_tl} {
            \seq_put_right:Nx \l_start_seq { \int_eval:n {\l_temp_int + \l_beat_count_int + (\l_maatra_int - 1) + 1} }
            \int_set:Nn \l_temp_int { \int_eval:n { (\l_temp_int + \l_beat_count_int + (\l_maatra_int - 1) + 1) } }
        }
        \seq_put_right:Nx \l_start_seq { \seq_count:N \l_cell_list_seq }
    \fi:
    
    % \seq_use:Nn \l_start_seq { , }

    % % %-----Calculate the number of times Taal bibhag symbol appears-----%
    
    
    \int_set:Nn \l_taal_bibhaga_int { \int_eval:n { \l_avartan_int * (\l_maatra_int - 1) } }
    % \int_use:N \l_taal_bibhaga_int
    % \int_use:N \l_maatra_int
    
    % % %-----Create Sequence holding the indexes of the Taal Bibhag Symbol-----%
    
    
    
    \int_set:Nn \l_i_int { 1 }
    
    \int_while_do:nn { \int_eval:n { \seq_count:N \l_taal_bibhag_seq + 1} <= \l_taal_bibhaga_int }{
        \int_compare:nNnTF { \int_mod:nn { \l_i_int } { \l_maatra_int } } = { 0 }
        {}
        {
            \seq_put_right:NV \l_taal_bibhag_seq \l_i_int
        }
        \int_incr:N \l_i_int
    }
    % \seq_use:Nn \l_taal_bibhag_seq { , }
    
    
    
    
    \int_set:Nn \l_i_int { 1 }
    
    \int_while_do:nn { \l_i_int <= \l_avartan_int }{
        \int_set:Nn \l_sum_int { 0 }
        \clist_map_variable:NNn \l_beat_pattern_clist \l_tmpa_int {
            \int_set:Nn \l_sum_int { \int_eval:n { \l_sum_int + \l_tmpa_int } }
            \int_compare:nNnTF { \l_sum_int } = { \l_beat_count_int }
            {
                
            }
            {
                \seq_put_right:NV \l_cum_taal_seq \l_sum_int
            }
        }
        \int_incr:N \l_i_int
    }
    
    % \seq_use:Nn \l_cum_taal_seq { , }
    
    \int_set:Nn \l_i_int { 0 }
    

    \int_while_do:nn { \l_i_int <= (\l_taal_bibhaga_int  - 1) }{
        \seq_put_right:Nx \l_taal_seq { \int_eval:n { (\l_beat_count_int * \fp_eval:n { floor(\l_i_int/(\l_maatra_int - 1)) } ) + 1 + \seq_item:Nn \l_taal_bibhag_seq { \l_i_int + 1 } + \seq_item:Nn \l_cum_taal_seq { \l_i_int + 1} } }
        \int_incr:N \l_i_int
    }
    
    % \seq_use:Nn \l_taal_seq { , }
    
    
    \seq_concat:NNN \l_taal_start_seq \l_start_seq \l_taal_seq
    \seq_map_variable:NNn \l_cell_list_seq \l_tmpa_int {
        \seq_if_in:NVF \l_taal_start_seq { \l_tmpa_int } {
            \seq_put_right:Nx \l_svar_index_seq { \l_tmpa_int }
        }
    }
    
    % %-----Calculating the indices of the Meend Symbols-----%
    
    
    
    \clist_set:Nn \l_svar_clist { #3 }
    
    
    \int_set:Nn \l_seq_int { 1 }
    
    \int_set:Nn \l_meend_true_int { 0 }

    \clist_map_variable:NNn \l_svar_clist \l_tmpa_tl {
        \tl_set:Nx \l_tmpb_tl { \tl_range:Nnn \l_tmpa_tl { 1 } { 1 } }
        \tl_if_eq:NnT \l_tmpb_tl  { ` } { 
            \seq_put_right:Nx \l_meend_index_seq { \int_use:N \l_seq_int }
            \int_set:Nn \l_meend_true_int { 1 }
        }
        \str_remove_all:Nn \l_tmpa_tl {`}
        \clist_put_right:Nx \l_svar_modified_clist { \l_tmpa_tl }
        \int_incr:N \l_seq_int
    }
    
    % \clist_use:Nn \l_svar_modified_clist { , }
    
    
    
    
    \int_set:Nn \l_index_int { 1 }
    \int_do_while:nn { \l_index_int <= \l_avartan_int } {
        \clist_concat:NNN \l_pattern_list_clist \l_pattern_list_clist \l_beat_pattern_clist
        \int_incr:N \l_index_int
    }
    
    
    \int_set:Nn \l_par_sum_int { 0 }
    \clist_map_variable:NNn \l_pattern_list_clist \l_tmpa_int {
        \int_set:Nn \l_par_sum_int { \int_eval:n { \l_par_sum_int + \l_tmpa_int } }
        \clist_put_right:Nx \l_pattern_cumul_clist { \int_use:N \l_par_sum_int }
    }
    
    
    
    \seq_set_from_clist:NN \l_pattern_cumul_seq \l_pattern_cumul_clist
    \int_set:Nn \l_serial_count_int { \seq_count:N \l_pattern_cumul_seq }
    \int_step_variable:nNn {\l_serial_count_int} {\l_start_tl} {
        \seq_put_right:Nx \l_serial_seq {\l_start_tl}
    }
    
    
    \seq_map_variable:NNn \l_meend_index_seq \l_tmpa_int {
        \int_set:Nn \l_index_int { 1 }
        \seq_map_variable:NNn \l_pattern_cumul_seq \l_tmpb_int {
            \int_compare:nT { \l_tmpa_int <= \l_tmpb_int } {
                \seq_put_right:Nx \l_meend_final_seq { \int_eval:n { \l_tmpa_int + \seq_item:Nn \l_serial_seq { \l_index_int } } }
                \seq_map_break:
            }
            \int_incr:N \l_index_int
        }
    }
    
    
    \seq_set_from_clist:NN \l_svar_seq \l_svar_clist
    \seq_set_from_clist:NN \l_svar_modified_seq \l_svar_modified_clist 
    
    \begin{figure}[!ht]
    \begin{tikzpicture}[squarednode/.style={rectangle, minimum~size=3mm, inner~sep=0, text~height=1mm}, node~distance=2mm]
    
    \seq_map_variable:NNn \l_cell_list_seq \l_tmpa_int {
        \seq_if_in:NVT \l_start_seq { \l_tmpa_int } {
            \if_int_compare:w \l_tmpa_int = 1
                \node[squarednode] (\l_tmpa_int) {\sffamily l};
            \else:
                \node[squarednode] [right=of~\int_eval:n { \l_tmpa_int - 1 }] (\l_tmpa_int) {\sffamily l};
            \fi:
        }
        \seq_if_in:NVT \l_svar_index_seq { \l_tmpa_int } {
            \seq_pop_left:NN \l_svar_modified_seq \l_tmpb_int
            \node[squarednode] [right=of~\int_eval:n { \l_tmpa_int - 1 }] (\l_tmpa_int) {\sffamily \l_tmpb_int};
        }
        \seq_if_in:NVT \l_taal_seq { \l_tmpa_int } {
            \node[squarednode] [right=of~\int_eval:n { \l_tmpa_int - 1 }] (\l_tmpa_int) {\sffamily A};
        }
        
    }
    
    \if_int_compare:w \l_meend_true_int = 1
        \seq_map_variable:NNn \l_serial_seq \l_tmpa_int {
            \if_int_compare:w \int_mod:nn { \l_tmpa_int } { 2 } = 0
                \draw~[fill=black,draw=black] (\seq_item:Nn \l_meend_final_seq { \l_tmpa_int-1 }.south)~to~[out=315,in=225]~( \seq_item:Nn \l_meend_final_seq { \int_eval:n { \l_tmpa_int } }.south)~to~[out=215,in=325]~cycle;
            \fi:
         }
    \fi:
    
    
    \end{tikzpicture}
    \end{figure} 
   
}
\ExplSyntaxOff

\ExplSyntaxOn
%-----command \scoreline to compose a single line of a score-----%
\newcommand{\scoreEndPhrase}[3]{
    \int_new:N \l_number_cells_int % Number of cells required to render the line
    \int_new:N \l_maatra_int % Number of measures in the input Taal
    \int_new:N \l_beat_count_int % Total number beat count in the input Taal
    \int_new:N \l_avartan_int % Number of input avartan
    \clist_new:N \l_beat_pattern_clist % Beat pattern of the input Taal
    \int_new:N \l_temp_int
    \clist_clear:N \l_svar_modified_clist

    
    % % %-----Local Variables-----%
    
    \int_set:Nn \l_number_cells_int { 0 } % represents no cell present at first
    \str_new:N \l_taal_str
    \str_set:Nn \l_taal_str { #1 } % sets the name of Taal

    \int_set:Nn \l_maatra_int { \cs:w c _\str_use:N \l_taal_str _maatra _int \cs_end: }
    \clist_set:Nx \l_beat_pattern_clist { \cs:w c _\str_use:N \l_taal_str _pattern _clist \cs_end: }

    \clist_map_variable:NNn \l_beat_pattern_clist \l_tmpa_int {
        \int_add:Nn \l_beat_count_int { \l_tmpa_int }
    }
    
    \int_set:Nn \l_avartan_int { #2 }

    \int_set:Nn \l_number_cells_int {  \int_eval:n {(\l_avartan_int * (\l_maatra_int - 1)) + (\l_beat_count_int * \l_avartan_int) + (\l_avartan_int - 1) + 2} }

    \seq_new:N \l_cell_list_seq
    \int_step_variable:nNn {\l_number_cells_int} {\l_start_tl} {
        \seq_put_right:Nx \l_cell_list_seq {\l_start_tl}
    }
    
    % \seq_use:Nn \l_cell_list_seq { , }
    
    \seq_new:N \l_start_seq
    \if_int_compare:w \l_avartan_int = 1
        \seq_put_right:Nx \l_start_seq { 1 }
        \seq_put_right:Nx \l_start_seq { \seq_count:N \l_cell_list_seq }    
    \else:
        \seq_put_right:Nx \l_start_seq { 1 }
        \int_set:Nn \l_temp_int { 1 }
        \int_step_variable:nNn { \int_eval:n { (\l_avartan_int - 1) } } {\l_start_tl} {
            \seq_put_right:Nx \l_start_seq { \int_eval:n {\l_temp_int + \l_beat_count_int + (\l_maatra_int - 1) + 1} }
            \int_set:Nn \l_temp_int { \int_eval:n { (\l_temp_int + \l_beat_count_int + (\l_maatra_int - 1) + 1) } }
        }
        \seq_put_right:Nx \l_start_seq { \seq_count:N \l_cell_list_seq }
    \fi:
    
    % \seq_use:Nn \l_start_seq { , }

    % % %-----Calculate the number of times Taal bibhag symbol appears-----%
    
    \int_new:N \l_taal_bibhaga_int
    \int_set:Nn \l_taal_bibhaga_int { \int_eval:n { \l_avartan_int * (\l_maatra_int - 1) } }
    % \int_use:N \l_taal_bibhaga_int
    % \int_use:N \l_maatra_int
    
    % % %-----Create Sequence holding the indexes of the Taal Bibhag Symbol-----%
    \seq_new:N \l_taal_bibhag_seq
    
    \int_new:N \l_i_int
    \int_set:Nn \l_i_int { 1 }
    
    \int_while_do:nn { \int_eval:n { \seq_count:N \l_taal_bibhag_seq + 1} <= \l_taal_bibhaga_int }{
        \int_compare:nNnTF { \int_mod:nn { \l_i_int } { \l_maatra_int } } = { 0 }
        {}
        {
            \seq_put_right:NV \l_taal_bibhag_seq \l_i_int
        }
        \int_incr:N \l_i_int
    }
    % \seq_use:Nn \l_taal_bibhag_seq { , }
    
    \seq_new:N \l_cum_taal_seq
    \int_new:N \l_sum_int
    
    \int_set:Nn \l_i_int { 1 }
    
    \int_while_do:nn { \l_i_int <= \l_avartan_int }{
        \int_set:Nn \l_sum_int { 0 }
        \clist_map_variable:NNn \l_beat_pattern_clist \l_tmpa_int {
            \int_set:Nn \l_sum_int { \int_eval:n { \l_sum_int + \l_tmpa_int } }
            \int_compare:nNnTF { \l_sum_int } = { \l_beat_count_int }
            {
                
            }
            {
                \seq_put_right:NV \l_cum_taal_seq \l_sum_int
            }
        }
        \int_incr:N \l_i_int
    }
    
    % \seq_use:Nn \l_cum_taal_seq { , }
    
    \int_set:Nn \l_i_int { 0 }
    \seq_new:N \l_taal_seq

    \int_while_do:nn { \l_i_int <= (\l_taal_bibhaga_int  - 1) }{
        \seq_put_right:Nx \l_taal_seq { \int_eval:n { (\l_beat_count_int * \fp_eval:n { floor(\l_i_int/(\l_maatra_int - 1)) } ) + 1 + \seq_item:Nn \l_taal_bibhag_seq { \l_i_int + 1 } + \seq_item:Nn \l_cum_taal_seq { \l_i_int + 1} } }
        \int_incr:N \l_i_int
    }
    
    % \seq_use:Nn \l_taal_seq { , }
    
    \seq_new:N \l_svar_index_seq
    \seq_concat:NNN \l_taal_start_seq \l_start_seq \l_taal_seq
    \seq_map_variable:NNn \l_cell_list_seq \l_tmpa_int {
        \seq_if_in:NVF \l_taal_start_seq { \l_tmpa_int } {
            \seq_put_right:Nx \l_svar_index_seq { \l_tmpa_int }
        }
    }
    
    % %-----Calculating the indices of the Meend Symbols-----%
    
    \clist_new:N \l_svar_clist
    \clist_new:N \l_svar_modified_clist
    \clist_set:Nn \l_svar_clist { #3 }
    \seq_new:N \l_meend_index_seq
    \int_new:N \l_seq_int
    \int_set:Nn \l_seq_int { 1 }
    \int_new:N \l_meend_true_int
    \int_set:Nn \l_meend_true_int { 0 }

    \clist_map_variable:NNn \l_svar_clist \l_tmpa_tl {
        \tl_set:Nx \l_tmpb_tl { \tl_range:Nnn \l_tmpa_tl { 1 } { 1 } }
        \tl_if_eq:NnT \l_tmpb_tl  { ` } { 
            \seq_put_right:Nx \l_meend_index_seq { \int_use:N \l_seq_int }
            \int_set:Nn \l_meend_true_int { 1 }
        }
        \str_remove_all:Nn \l_tmpa_tl {`}
        \clist_put_right:Nx \l_svar_modified_clist { \l_tmpa_tl }
        \int_incr:N \l_seq_int
    }
    
    % \clist_use:Nn \l_svar_modified_clist { , }
    \clist_new:N \l_pattern_list_clist
    
    
    \int_new:N \l_index_int
    \int_set:Nn \l_index_int { 1 }
    \int_do_while:nn { \l_index_int <= \l_avartan_int } {
        \clist_concat:NNN \l_pattern_list_clist \l_pattern_list_clist \l_beat_pattern_clist
        \int_incr:N \l_index_int
    }
    
    \clist_new:N \l_pattern_cumul_clist
    \int_new:N \l_par_sum_int
    \int_set:Nn \l_par_sum_int { 0 }
    \clist_map_variable:NNn \l_pattern_list_clist \l_tmpa_int {
        \int_set:Nn \l_par_sum_int { \int_eval:n { \l_par_sum_int + \l_tmpa_int } }
        \clist_put_right:Nx \l_pattern_cumul_clist { \int_use:N \l_par_sum_int }
    }
    
    
    \seq_new:N \l_serial_seq
    \int_new:N \l_serial_count_int
    \seq_new:N \l_pattern_cumul_seq
    \seq_set_from_clist:NN \l_pattern_cumul_seq \l_pattern_cumul_clist
    \int_set:Nn \l_serial_count_int { \seq_count:N \l_pattern_cumul_seq }
    \int_step_variable:nNn {\l_serial_count_int} {\l_start_tl} {
        \seq_put_right:Nx \l_serial_seq {\l_start_tl}
    }
    
    \seq_new:N \l_meend_final_seq
    \seq_map_variable:NNn \l_meend_index_seq \l_tmpa_int {
        \int_set:Nn \l_index_int { 1 }
        \seq_map_variable:NNn \l_pattern_cumul_seq \l_tmpb_int {
            \int_compare:nT { \l_tmpa_int <= \l_tmpb_int } {
                \seq_put_right:Nx \l_meend_final_seq { \int_eval:n { \l_tmpa_int + \seq_item:Nn \l_serial_seq { \l_index_int } } }
                \seq_map_break:
            }
            \int_incr:N \l_index_int
        }
    }
    
    \seq_new:N \l_svar_modified_seq
    \seq_new:N \l_svar_seq
    \seq_set_from_clist:NN \l_svar_seq \l_svar_clist
    \seq_set_from_clist:NN \l_svar_modified_seq \l_svar_modified_clist 

    \begin{figure}[!ht]
    \begin{tikzpicture}[squarednode/.style={rectangle, minimum~size=3mm, inner~sep=0, text~height=1mm}, node~distance=2mm]
    
    \seq_map_variable:NNn \l_cell_list_seq \l_tmpa_int {
        \seq_if_in:NVT \l_start_seq { \l_tmpa_int } {
            \if_int_compare:w \l_tmpa_int = 1
                \node[squarednode] (\l_tmpa_int) {\sffamily l};
            \else:
                \if_int_compare:w \l_tmpa_int = \l_number_cells_int
                    \node[squarednode] [right=of~\int_eval:n { \l_tmpa_int - 1 }] (\l_tmpa_int) {\sffamily L};
                \else:
                    \node[squarednode] [right=of~\int_eval:n { \l_tmpa_int - 1 }] (\l_tmpa_int) {\sffamily l};
                \fi:
            \fi:
        }
        \seq_if_in:NVT \l_svar_index_seq { \l_tmpa_int } {
            \seq_pop_left:NN \l_svar_seq \l_tmpb_int
            \node[squarednode] [right=of~\int_eval:n { \l_tmpa_int - 1 }] (\l_tmpa_int) {\sffamily \l_tmpb_int};
        }
        \seq_if_in:NVT \l_taal_seq { \l_tmpa_int } {
            \node[squarednode] [right=of~\int_eval:n { \l_tmpa_int - 1 }] (\l_tmpa_int) {\sffamily A};
        }
        
    }
    
    \if_int_compare:w \l_meend_true_int = 1
        \seq_map_variable:NNn \l_serial_seq \l_tmpa_int {
            \if_int_compare:w \int_mod:nn { \l_tmpa_int } { 2 } = 0
                \draw~[fill=black,draw=black] (\seq_item:Nn \l_meend_final_seq { \l_tmpa_int-1 }.south)~to~[out=315,in=225]~( \seq_item:Nn \l_meend_final_seq { \int_eval:n { \l_tmpa_int } }.south)~to~[out=215,in=325]~cycle;
            \fi:
         }
    \fi:
    
    \end{tikzpicture}
    \end{figure} 
   
}
\ExplSyntaxOff

\ExplSyntaxOn
%-----command \scoreNewPhrase to compose a new phrase of a score-----%
\newcommand{\scoreNewPhrase}[3]{
    \int_new:N \l_number_cells_int % Number of cells required to render the line
    \int_new:N \l_maatra_int % Number of measures in the input Taal
    \int_new:N \l_beat_count_int % Total number beat count in the input Taal
    \int_new:N \l_avartan_int % Number of input avartan
    \clist_new:N \l_beat_pattern_clist % Beat pattern of the input Taal
    \int_new:N \l_temp_int
    
    % % %-----Local Variables-----%
    
    \int_set:Nn \l_number_cells_int { 0 } % represents no cell present at first
    \str_new:N \l_taal_str
    \str_set:Nn \l_taal_str { #1 } % sets the name of Taal

    \int_set:Nn \l_maatra_int { \cs:w c _\str_use:N \l_taal_str _maatra _int \cs_end: }
    \clist_set:Nx \l_beat_pattern_clist { \cs:w c _\str_use:N \l_taal_str _pattern _clist \cs_end: }

    \clist_map_variable:NNn \l_beat_pattern_clist \l_tmpa_int {
        \int_add:Nn \l_beat_count_int { \l_tmpa_int }
    }
    
    \int_set:Nn \l_avartan_int { #2 }

    \int_set:Nn \l_number_cells_int {  \int_eval:n {(\l_avartan_int * (\l_maatra_int - 1)) + (\l_beat_count_int * \l_avartan_int) + (\l_avartan_int - 1) + 2} }

    \seq_new:N \l_cell_list_seq
    \int_step_variable:nNn {\l_number_cells_int} {\l_start_tl} {
        \seq_put_right:Nx \l_cell_list_seq {\l_start_tl}
    }
    
    % \seq_use:Nn \l_cell_list_seq { , }
    
    \seq_new:N \l_start_seq
    \if_int_compare:w \l_avartan_int = 1
        \seq_put_right:Nx \l_start_seq { 1 }
        \seq_put_right:Nx \l_start_seq { \seq_count:N \l_cell_list_seq }    
    \else:
        \seq_put_right:Nx \l_start_seq { 1 }
        \int_set:Nn \l_temp_int { 1 }
        \int_step_variable:nNn { \int_eval:n { (\l_avartan_int - 1) } } {\l_start_tl} {
            \seq_put_right:Nx \l_start_seq { \int_eval:n {\l_temp_int + \l_beat_count_int + (\l_maatra_int - 1) + 1} }
            \int_set:Nn \l_temp_int { \int_eval:n { (\l_temp_int + \l_beat_count_int + (\l_maatra_int - 1) + 1) } }
        }
        \seq_put_right:Nx \l_start_seq { \seq_count:N \l_cell_list_seq }
    \fi:
    
    % \seq_use:Nn \l_start_seq { , }

    % % %-----Calculate the number of times Taal bibhag symbol appears-----%
    
    \int_new:N \l_taal_bibhaga_int
    \int_set:Nn \l_taal_bibhaga_int { \int_eval:n { \l_avartan_int * (\l_maatra_int - 1) } }
    % \int_use:N \l_taal_bibhaga_int
    % \int_use:N \l_maatra_int
    
    % % %-----Create Sequence holding the indexes of the Taal Bibhag Symbol-----%
    \seq_new:N \l_taal_bibhag_seq
    
    \int_new:N \l_i_int
    \int_set:Nn \l_i_int { 1 }
    
    \int_while_do:nn { \int_eval:n { \seq_count:N \l_taal_bibhag_seq + 1} <= \l_taal_bibhaga_int }{
        \int_compare:nNnTF { \int_mod:nn { \l_i_int } { \l_maatra_int } } = { 0 }
        {}
        {
            \seq_put_right:NV \l_taal_bibhag_seq \l_i_int
        }
        \int_incr:N \l_i_int
    }
    % \seq_use:Nn \l_taal_bibhag_seq { , }
    
    \seq_new:N \l_cum_taal_seq
    \int_new:N \l_sum_int
    
    \int_set:Nn \l_i_int { 1 }
    
    \int_while_do:nn { \l_i_int <= \l_avartan_int }{
        \int_set:Nn \l_sum_int { 0 }
        \clist_map_variable:NNn \l_beat_pattern_clist \l_tmpa_int {
            \int_set:Nn \l_sum_int { \int_eval:n { \l_sum_int + \l_tmpa_int } }
            \int_compare:nNnTF { \l_sum_int } = { \l_beat_count_int }
            {
                
            }
            {
                \seq_put_right:NV \l_cum_taal_seq \l_sum_int
            }
        }
        \int_incr:N \l_i_int
    }
    
    % \seq_use:Nn \l_cum_taal_seq { , }
    
    \int_set:Nn \l_i_int { 0 }
    \seq_new:N \l_taal_seq

    \int_while_do:nn { \l_i_int <= (\l_taal_bibhaga_int  - 1) }{
        \seq_put_right:Nx \l_taal_seq { \int_eval:n { (\l_beat_count_int * \fp_eval:n { floor(\l_i_int/(\l_maatra_int - 1)) } ) + 1 + \seq_item:Nn \l_taal_bibhag_seq { \l_i_int + 1 } + \seq_item:Nn \l_cum_taal_seq { \l_i_int + 1} } }
        \int_incr:N \l_i_int
    }
    
    % \seq_use:Nn \l_taal_seq { , }
    
    \seq_new:N \l_svar_index_seq
    \seq_concat:NNN \l_taal_start_seq \l_start_seq \l_taal_seq
    \seq_map_variable:NNn \l_cell_list_seq \l_tmpa_int {
        \seq_if_in:NVF \l_taal_start_seq { \l_tmpa_int } {
            \seq_put_right:Nx \l_svar_index_seq { \l_tmpa_int }
        }
    }
    
    % %-----Calculating the indices of the Meend Symbols-----%
    
    \clist_new:N \l_svar_clist
    \clist_set:Nn \l_svar_clist { #3 }
    \seq_new:N \l_meend_index_seq
    \int_new:N \l_seq_int
    \int_set:Nn \l_seq_int { 1 }
    
    \clist_map_variable:NNn \l_svar_clist \l_tmpa_tl {
        \tl_set:Nx \l_tmpb_tl { \tl_range:Nnn \l_tmpa_tl { 1 } { 1 } }
        \tl_if_eq:NnT \l_tmpb_tl  { ~ } { 
            \seq_put_right:Nx \l_meend_index_seq { \int_use:N \l_seq_int }
        }
        \int_incr:N \l_seq_int
    }
    
    \clist_new:N \l_pattern_list_clist
    
    
    \int_new:N \l_index_int
    \int_set:Nn \l_index_int { 1 }
    \int_do_while:nn { \l_index_int <= \l_avartan_int } {
        \clist_concat:NNN \l_pattern_list_clist \l_pattern_list_clist \l_beat_pattern_clist
        \int_incr:N \l_index_int
    }
    
    \clist_new:N \l_pattern_cumul_clist
    \int_new:N \l_par_sum_int
    \int_set:Nn \l_par_sum_int { 0 }
    \clist_map_variable:NNn \l_pattern_list_clist \l_tmpa_int {
        \int_set:Nn \l_par_sum_int { \int_eval:n { \l_par_sum_int + \l_tmpa_int } }
        \clist_put_right:Nx \l_pattern_cumul_clist { \int_use:N \l_par_sum_int }
    }
    
    
    \seq_new:N \l_serial_seq
    \int_new:N \l_serial_count_int
    \seq_new:N \l_pattern_cumul_seq
    \seq_set_from_clist:NN \l_pattern_cumul_seq \l_pattern_cumul_clist
    \int_set:Nn \l_serial_count_int { \seq_count:N \l_pattern_cumul_seq }
    \int_step_variable:nNn {\l_serial_count_int} {\l_start_tl} {
        \seq_put_right:Nx \l_serial_seq {\l_start_tl}
    }
    
    \seq_new:N \l_meend_final_seq
    \seq_map_variable:NNn \l_meend_index_seq \l_tmpa_int {
        \int_set:Nn \l_index_int { 1 }
        \seq_map_variable:NNn \l_pattern_cumul_seq \l_tmpb_int {
            \int_compare:nT { \l_tmpa_int <= \l_tmpb_int } {
                \seq_put_right:Nx \l_meend_final_seq { \int_eval:n { \l_tmpa_int + \seq_item:Nn \l_serial_seq { \l_index_int } } }
                \seq_map_break:
            }
            \int_incr:N \l_index_int
        }
    }
    
    \seq_new:N \l_svar_seq
    \seq_set_from_clist:NN \l_svar_seq \l_svar_clist
    
    \begin{figure}[!ht]
    \begin{tikzpicture}[squarednode/.style={rectangle, minimum~size=3mm, inner~sep=0, text~height=1mm}, node~distance=2mm]
    
    \seq_map_variable:NNn \l_cell_list_seq \l_tmpa_int {
        \seq_if_in:NVT \l_start_seq { \l_tmpa_int } {
            \if_int_compare:w \l_tmpa_int = 1
                \node[squarednode] (\l_tmpa_int) {\sffamily L};
            \else:
                \node[squarednode] [right=of~\int_eval:n { \l_tmpa_int - 1 }] (\l_tmpa_int) {\sffamily l};
            \fi:
        }
        \seq_if_in:NVT \l_svar_index_seq { \l_tmpa_int } {
            \seq_pop_left:NN \l_svar_seq \l_tmpb_int
            \node[squarednode] [right=of~\int_eval:n { \l_tmpa_int - 1 }] (\l_tmpa_int) {\sffamily \l_tmpb_int};
        }
        \seq_if_in:NVT \l_taal_seq { \l_tmpa_int } {
            \node[squarednode] [right=of~\int_eval:n { \l_tmpa_int - 1 }] (\l_tmpa_int) {\sffamily A};
        }
        
    }
    
    \seq_map_variable:NNn \l_serial_seq \l_tmpa_int {
        \if_int_compare:w \int_mod:nn { \l_tmpa_int } { 2 } = 0
            \draw~[fill=black,draw=black] (\seq_item:Nn \l_meend_final_seq { \l_tmpa_int-1 }.south)~to~[out=315,in=225]~( \seq_item:Nn \l_meend_final_seq { \int_eval:n { \l_tmpa_int } }.south)~to~[out=215,in=325]~cycle;
        \fi:
    }
    
    \end{tikzpicture}
    \end{figure} 
   
}
\ExplSyntaxOff

\ExplSyntaxOn
%-----command \scoreline to compose a single line of a score and lyrics-----%
\newcommand{\scoreLyricNewPhrase}[4]{
    
    %-----clear all the sequences and clists-----%
    \clist_clear:N \l_beat_pattern_clist
    \seq_clear:N \l_cell_list_seq
    \seq_clear:N \l_start_seq
    \seq_clear:N \l_taal_bibhag_seq
    \seq_clear:N \l_taal_seq
    \seq_clear:N \l_taal_start_seq
    \seq_clear:N \l_svar_index_seq
    \clist_clear:N \l_svar_clist
    \clist_clear:N \l_svar_modified_clist
    \seq_clear:N \l_meend_index_seq
    \clist_clear:N \l_pattern_list_clist
    \clist_clear:N \l_pattern_cumul_clist
    \seq_clear:N \l_pattern_cumul_seq
    \seq_clear:N \l_serial_seq
    \seq_clear:N \l_meend_final_seq
    
    \int_new:N \l_taal_bibhaga_int
    \int_new:N \l_number_cells_int
    \int_new:N \l_maatra_int
    \int_new:N \l_beat_count_int
    \int_new:N \l_avartan_int
    \int_new:N \l_index_int
    \int_set:Nn \l_number_cells_int { 0 } % represents no cell present at first
    \int_set:Nn \l_maatra_int { 0 } % represents no cell present at first
    \int_set:Nn \l_beat_count_int { 0 } % represents no cell present at first
    \int_set:Nn \l_avartan_int { 0 } % represents no cell present at first
    \int_new:N \l_loc_int
    
    \clist_new:N \l_lyric_clist
    
    \str_set:Nn \l_taal_str { #1 } % sets the name of Taal
    \int_set:Nn \l_maatra_int { \cs:w c _\str_use:N \l_taal_str _maatra _int \cs_end: }
    \clist_set:Nx \l_beat_pattern_clist { \cs:w c _\str_use:N \l_taal_str _pattern _clist \cs_end: }
    
    \clist_map_variable:NNn \l_beat_pattern_clist \l_tmpa_int {
        \int_add:Nn \l_beat_count_int { \l_tmpa_int }
    }
    
    
    \int_set:Nn \l_avartan_int { #2 }

    \int_set:Nn \l_number_cells_int {  \int_eval:n {(\l_avartan_int * (\l_maatra_int - 1)) + (\l_beat_count_int * \l_avartan_int) + (\l_avartan_int - 1) + 2} }
    
    \int_step_variable:nNn {\l_number_cells_int} {\l_start_tl} {
        \seq_put_right:Nx \l_cell_list_seq {\l_start_tl}
    }
    
    \if_int_compare:w \l_avartan_int = 1
        \seq_put_right:Nx \l_start_seq { 1 }
        \seq_put_right:Nx \l_start_seq { \seq_count:N \l_cell_list_seq }    
    \else:
        \seq_put_right:Nx \l_start_seq { 1 }
        \seq_put_right:Nx \l_start_seq { \int_eval:n { (\seq_count:N \l_cell_list_seq + 1) / 2 } }
        \seq_put_right:Nx \l_start_seq { \seq_count:N \l_cell_list_seq }
    \fi:
    
    \int_set:Nn \l_taal_bibhaga_int { \int_eval:n { \l_avartan_int * (\l_maatra_int - 1) } }
    
    \int_new:N \l_i_int
    \int_set:Nn \l_i_int { 1 }
    
    \int_while_do:nn { \int_eval:n { \seq_count:N \l_taal_bibhag_seq + 1} <= \l_taal_bibhaga_int }{
        \int_compare:nNnTF { \int_mod:nn { \l_i_int } { \l_maatra_int } } = { 0 }
        {}
        {
            \seq_put_right:NV \l_taal_bibhag_seq \l_i_int
        }
        \int_incr:N \l_i_int
    }
    % \seq_use:Nn \l_taal_bibhag_seq { , }
    
    \seq_new:N \l_cum_taal_seq
    \int_new:N \l_sum_int
    
    \int_set:Nn \l_i_int { 1 }
    
    \int_while_do:nn { \l_i_int <= \l_avartan_int }{
        \int_set:Nn \l_sum_int { 0 }
        \clist_map_variable:NNn \l_beat_pattern_clist \l_tmpa_int {
            \int_set:Nn \l_sum_int { \int_eval:n { \l_sum_int + \l_tmpa_int } }
            \int_compare:nNnTF { \l_sum_int } = { \l_beat_count_int }
            {
                
            }
            {
                \seq_put_right:NV \l_cum_taal_seq \l_sum_int
            }
        }
        \int_incr:N \l_i_int
    }
    
    % \seq_use:Nn \l_cum_taal_seq { , }
    
    \int_set:Nn \l_i_int { 0 }

    \int_while_do:nn { \l_i_int <= (\l_taal_bibhaga_int  - 1) }{
        \seq_put_right:Nx \l_taal_seq { \int_eval:n { (\l_beat_count_int * \fp_eval:n { floor(\l_i_int/(\l_maatra_int - 1)) } ) + 1 + \seq_item:Nn \l_taal_bibhag_seq { \l_i_int + 1 } + \seq_item:Nn \l_cum_taal_seq { \l_i_int + 1} } }
        \int_incr:N \l_i_int
    }
    
    % \seq_use:Nn \l_taal_seq { , }
    
    \seq_concat:NNN \l_taal_start_seq \l_start_seq \l_taal_seq
    \seq_map_variable:NNn \l_cell_list_seq \l_tmpa_int {
        \seq_if_in:NVF \l_taal_start_seq { \l_tmpa_int } {
            \seq_put_right:Nx \l_svar_index_seq { \l_tmpa_int }
        }
    }
    
    \clist_set:Nn \l_svar_clist { #3 }
    \seq_set_from_clist:NN \l_svar_seq \l_svar_clist
    \clist_set:Nn \l_lyric_clist { #4 }
    \seq_set_from_clist:NN \l_lyric_seq \l_lyric_clist

    %-----Calculating the indices of the Meend Symbols-----%
    \clist_set:Nn \l_svar_clist { #3 }
    \int_new:N \l_seq_int
    \int_set:Nn \l_seq_int { 1 }
    \int_new:N \l_meend_true_int
    \int_set:Nn \l_meend_true_int { 0 }

    \clist_map_variable:NNn \l_svar_clist \l_tmpa_tl {
        \tl_set:Nx \l_tmpb_tl { \tl_range:Nnn \l_tmpa_tl { 1 } { 1 } }
        \tl_if_eq:NnT \l_tmpb_tl  { ` } { 
            \seq_put_right:Nx \l_meend_index_seq { \int_use:N \l_seq_int }
            \int_set:Nn \l_meend_true_int { 1 }
        }
        \str_remove_all:Nn \l_tmpa_tl {`}
        \clist_put_right:Nx \l_svar_modified_clist { \l_tmpa_tl }
        \int_incr:N \l_seq_int
    }
    
    % \clist_use:Nn \l_svar_modified_clist { , }

    
    \int_set:Nn \l_index_int { 1 }
    \int_do_while:nn { \l_index_int <= \l_avartan_int } {
        \clist_concat:NNN \l_pattern_list_clist \l_pattern_list_clist \l_beat_pattern_clist
        \int_incr:N \l_index_int
    }
    
    \int_new:N \l_par_sum_int
    \int_set:Nn \l_par_sum_int { 0 }
    \clist_map_variable:NNn \l_pattern_list_clist \l_tmpa_int {
        \int_set:Nn \l_par_sum_int { \int_eval:n { \l_par_sum_int + \l_tmpa_int } }
        \clist_put_right:Nx \l_pattern_cumul_clist { \int_use:N \l_par_sum_int }
    }
    
    
    \int_new:N \l_serial_count_int
    \seq_set_from_clist:NN \l_pattern_cumul_seq \l_pattern_cumul_clist
    \int_set:Nn \l_serial_count_int { \seq_count:N \l_pattern_cumul_seq }
    \int_step_variable:nNn {\l_serial_count_int} {\l_start_tl} {
        \seq_put_right:Nx \l_serial_seq {\l_start_tl}
    }
    
    \seq_map_variable:NNn \l_meend_index_seq \l_tmpa_int {
        \int_set:Nn \l_index_int { 1 }
        \seq_map_variable:NNn \l_pattern_cumul_seq \l_tmpb_int {
            \int_compare:nT { \l_tmpa_int <= \l_tmpb_int } {
                \seq_put_right:Nx \l_meend_final_seq { \int_eval:n { \l_tmpa_int + \seq_item:Nn \l_serial_seq { \l_index_int } } }
                \seq_map_break:
            }
            \int_incr:N \l_index_int
        }
    }
    
    \seq_new:N \l_svar_modified_seq
    \seq_set_from_clist:NN \l_svar_seq \l_svar_clist
    \seq_set_from_clist:NN \l_svar_modified_seq \l_svar_modified_clist
    
    \begin{figure}[!ht]
    % \centering
    \begin{tikzpicture}[squarednode/.style={rectangle, minimum~size=3mm, inner~sep=0, text~height=1mm}, node~distance=2mm]
    
    \seq_map_variable:NNn \l_cell_list_seq \l_tmpa_int {
        \seq_if_in:NVT \l_start_seq { \l_tmpa_int } {
            \if_int_compare:w \l_tmpa_int = 1
                \node[squarednode] (\l_tmpa_int) {\sffamily L};
            \else:
                \node[squarednode] [right=of~\int_eval:n { \l_tmpa_int - 1 }] (\l_tmpa_int) {\sffamily l};
            \fi:
        }
        \seq_if_in:NVT \l_svar_index_seq { \l_tmpa_int } {
            \seq_pop_left:NN \l_svar_seq \l_loc_int
            \node[squarednode] [right=of~\int_eval:n { \l_tmpa_int - 1 }] (\l_tmpa_int) {\sffamily \l_loc_int};
        }
        \seq_if_in:NVT \l_svar_index_seq { \l_tmpa_int } {
            \seq_pop_left:NN \l_lyric_seq \l_loc_int
            \node[squarednode] [below=5mm~of~\int_eval:n { \l_tmpa_int}] {\ttfamily \l_loc_int};
        }
        \seq_if_in:NVT \l_taal_seq { \l_tmpa_int } {
            \node[squarednode] [right=of~\int_eval:n { \l_tmpa_int - 1 }] (\l_tmpa_int) {\sffamily A};
        }
        
    }
    
    \if_int_compare:w \l_meend_true_int = 1
        \seq_map_variable:NNn \l_serial_seq \l_tmpa_int {
            \if_int_compare:w \int_mod:nn { \l_tmpa_int } { 2 } = 0
                \draw~[fill=black,draw=black] (\seq_item:Nn \l_meend_final_seq { \l_tmpa_int-1 }.south)~to~[out=315,in=225]~( \seq_item:Nn \l_meend_final_seq { \int_eval:n { \l_tmpa_int } }.south)~to~[out=215,in=325]~cycle;
            \fi:
         }
    \fi:
    
    \end{tikzpicture}
    \end{figure} 
}
\ExplSyntaxOff

\ExplSyntaxOn
%-----command \scoreline to compose a single line of a score and lyrics-----%
\newcommand{\scorelyricline}[4]{
    
    %-----clear all the sequences and clists-----%
    \clist_clear:N \l_beat_pattern_clist
    \seq_clear:N \l_cell_list_seq
    \seq_clear:N \l_start_seq
    \seq_clear:N \l_taal_bibhag_seq
    \seq_clear:N \l_taal_seq
    \seq_clear:N \l_taal_start_seq
    \seq_clear:N \l_svar_index_seq
    \clist_clear:N \l_svar_clist
    \clist_clear:N \l_svar_modified_clist
    \seq_clear:N \l_meend_index_seq
    \clist_clear:N \l_pattern_list_clist
    \clist_clear:N \l_pattern_cumul_clist
    \seq_clear:N \l_pattern_cumul_seq
    \seq_clear:N \l_serial_seq
    \seq_clear:N \l_meend_final_seq
    
    \int_new:N \l_taal_bibhaga_int
    \int_new:N \l_number_cells_int
    \int_new:N \l_maatra_int
    \int_new:N \l_beat_count_int
    \int_new:N \l_avartan_int
    \int_new:N \l_index_int
    \int_set:Nn \l_number_cells_int { 0 } % represents no cell present at first
    \int_set:Nn \l_maatra_int { 0 } % represents no cell present at first
    \int_set:Nn \l_beat_count_int { 0 } % represents no cell present at first
    \int_set:Nn \l_avartan_int { 0 } % represents no cell present at first
    \int_new:N \l_loc_int
    
    \clist_new:N \l_lyric_clist
    
    \str_set:Nn \l_taal_str { #1 } % sets the name of Taal
    \int_set:Nn \l_maatra_int { \cs:w c _\str_use:N \l_taal_str _maatra _int \cs_end: }
    \clist_set:Nx \l_beat_pattern_clist { \cs:w c _\str_use:N \l_taal_str _pattern _clist \cs_end: }
    
    \clist_map_variable:NNn \l_beat_pattern_clist \l_tmpa_int {
        \int_add:Nn \l_beat_count_int { \l_tmpa_int }
    }
    
    
    \int_set:Nn \l_avartan_int { #2 }

    \int_set:Nn \l_number_cells_int {  \int_eval:n {(\l_avartan_int * (\l_maatra_int - 1)) + (\l_beat_count_int * \l_avartan_int) + (\l_avartan_int - 1) + 2} }
    
    \int_step_variable:nNn {\l_number_cells_int} {\l_start_tl} {
        \seq_put_right:Nx \l_cell_list_seq {\l_start_tl}
    }
    
    \if_int_compare:w \l_avartan_int = 1
        \seq_put_right:Nx \l_start_seq { 1 }
        \seq_put_right:Nx \l_start_seq { \seq_count:N \l_cell_list_seq }    
    \else:
        \seq_put_right:Nx \l_start_seq { 1 }
        \seq_put_right:Nx \l_start_seq { \int_eval:n { (\seq_count:N \l_cell_list_seq + 1) / 2 } }
        \seq_put_right:Nx \l_start_seq { \seq_count:N \l_cell_list_seq }
    \fi:
    
    \int_set:Nn \l_taal_bibhaga_int { \int_eval:n { \l_avartan_int * (\l_maatra_int - 1) } }
    
    \int_new:N \l_i_int
    \int_set:Nn \l_i_int { 1 }
    
    \int_while_do:nn { \int_eval:n { \seq_count:N \l_taal_bibhag_seq + 1} <= \l_taal_bibhaga_int }{
        \int_compare:nNnTF { \int_mod:nn { \l_i_int } { \l_maatra_int } } = { 0 }
        {}
        {
            \seq_put_right:NV \l_taal_bibhag_seq \l_i_int
        }
        \int_incr:N \l_i_int
    }
    % \seq_use:Nn \l_taal_bibhag_seq { , }
    
    \seq_new:N \l_cum_taal_seq
    \int_new:N \l_sum_int
    
    \int_set:Nn \l_i_int { 1 }
    
    \int_while_do:nn { \l_i_int <= \l_avartan_int }{
        \int_set:Nn \l_sum_int { 0 }
        \clist_map_variable:NNn \l_beat_pattern_clist \l_tmpa_int {
            \int_set:Nn \l_sum_int { \int_eval:n { \l_sum_int + \l_tmpa_int } }
            \int_compare:nNnTF { \l_sum_int } = { \l_beat_count_int }
            {
                
            }
            {
                \seq_put_right:NV \l_cum_taal_seq \l_sum_int
            }
        }
        \int_incr:N \l_i_int
    }
    
    % \seq_use:Nn \l_cum_taal_seq { , }
    
    \int_set:Nn \l_i_int { 0 }

    \int_while_do:nn { \l_i_int <= (\l_taal_bibhaga_int  - 1) }{
        \seq_put_right:Nx \l_taal_seq { \int_eval:n { (\l_beat_count_int * \fp_eval:n { floor(\l_i_int/(\l_maatra_int - 1)) } ) + 1 + \seq_item:Nn \l_taal_bibhag_seq { \l_i_int + 1 } + \seq_item:Nn \l_cum_taal_seq { \l_i_int + 1} } }
        \int_incr:N \l_i_int
    }
    
    % \seq_use:Nn \l_taal_seq { , }
    
    \seq_concat:NNN \l_taal_start_seq \l_start_seq \l_taal_seq
    \seq_map_variable:NNn \l_cell_list_seq \l_tmpa_int {
        \seq_if_in:NVF \l_taal_start_seq { \l_tmpa_int } {
            \seq_put_right:Nx \l_svar_index_seq { \l_tmpa_int }
        }
    }
    
    \clist_set:Nn \l_svar_clist { #3 }
    \seq_set_from_clist:NN \l_svar_seq \l_svar_clist
    \clist_set:Nn \l_lyric_clist { #4 }
    \seq_set_from_clist:NN \l_lyric_seq \l_lyric_clist

    % %-----Calculating the indices of the Meend Symbols-----%
    \clist_set:Nn \l_svar_clist { #3 }
    \int_new:N \l_seq_int
    \int_set:Nn \l_seq_int { 1 }
    \int_new:N \l_meend_true_int
    \int_set:Nn \l_meend_true_int { 0 }

    \clist_map_variable:NNn \l_svar_clist \l_tmpa_tl {
        \tl_set:Nx \l_tmpb_tl { \tl_range:Nnn \l_tmpa_tl { 1 } { 1 } }
        \tl_if_eq:NnT \l_tmpb_tl  { ` } { 
            \seq_put_right:Nx \l_meend_index_seq { \int_use:N \l_seq_int }
            \int_set:Nn \l_meend_true_int { 1 }
        }
        \str_remove_all:Nn \l_tmpa_tl {`}
        \clist_put_right:Nx \l_svar_modified_clist { \l_tmpa_tl }
        \int_incr:N \l_seq_int
    }
    
    % \clist_use:Nn \l_svar_modified_clist { , }

    
    \int_set:Nn \l_index_int { 1 }
    \int_do_while:nn { \l_index_int <= \l_avartan_int } {
        \clist_concat:NNN \l_pattern_list_clist \l_pattern_list_clist \l_beat_pattern_clist
        \int_incr:N \l_index_int
    }
    
    \int_new:N \l_par_sum_int
    \int_set:Nn \l_par_sum_int { 0 }
    \clist_map_variable:NNn \l_pattern_list_clist \l_tmpa_int {
        \int_set:Nn \l_par_sum_int { \int_eval:n { \l_par_sum_int + \l_tmpa_int } }
        \clist_put_right:Nx \l_pattern_cumul_clist { \int_use:N \l_par_sum_int }
    }
    
    
    \int_new:N \l_serial_count_int
    \seq_set_from_clist:NN \l_pattern_cumul_seq \l_pattern_cumul_clist
    \int_set:Nn \l_serial_count_int { \seq_count:N \l_pattern_cumul_seq }
    \int_step_variable:nNn {\l_serial_count_int} {\l_start_tl} {
        \seq_put_right:Nx \l_serial_seq {\l_start_tl}
    }
    
    \seq_map_variable:NNn \l_meend_index_seq \l_tmpa_int {
        \int_set:Nn \l_index_int { 1 }
        \seq_map_variable:NNn \l_pattern_cumul_seq \l_tmpb_int {
            \int_compare:nT { \l_tmpa_int <= \l_tmpb_int } {
                \seq_put_right:Nx \l_meend_final_seq { \int_eval:n { \l_tmpa_int + \seq_item:Nn \l_serial_seq { \l_index_int } } }
                \seq_map_break:
            }
            \int_incr:N \l_index_int
        }
    }
    
    \seq_new:N \l_svar_modified_seq
    \seq_set_from_clist:NN \l_svar_seq \l_svar_clist
    \seq_set_from_clist:NN \l_svar_modified_seq \l_svar_modified_clist
    
    \begin{figure}[!ht]
    % \centering
    \begin{tikzpicture}[squarednode/.style={rectangle, minimum~size=3mm, inner~sep=0, text~height=1mm}, node~distance=2mm]
    
    \seq_map_variable:NNn \l_cell_list_seq \l_tmpa_int {
        \seq_if_in:NVT \l_start_seq { \l_tmpa_int } {
            \if_int_compare:w \l_tmpa_int = 1
                \node[squarednode] (\l_tmpa_int) {\sffamily l};
            \else:
                \node[squarednode] [right=of~\int_eval:n { \l_tmpa_int - 1 }] (\l_tmpa_int) {\sffamily l};
            \fi:
        }
        \seq_if_in:NVT \l_svar_index_seq { \l_tmpa_int } {
            \seq_pop_left:NN \l_svar_modified_seq \l_loc_int
            \node[squarednode] [right=of~\int_eval:n { \l_tmpa_int - 1 }] (\l_tmpa_int) {\sffamily \l_loc_int};
        }
        \seq_if_in:NVT \l_svar_index_seq { \l_tmpa_int } {
            \seq_pop_left:NN \l_lyric_seq \l_loc_int
            \node[squarednode] [below=5mm~of~\int_eval:n { \l_tmpa_int}] {\ttfamily \l_loc_int};
        }
        \seq_if_in:NVT \l_taal_seq { \l_tmpa_int } {
            \node[squarednode] [right=of~\int_eval:n { \l_tmpa_int - 1 }] (\l_tmpa_int) {\sffamily A};
        }
        
    }
    
    \if_int_compare:w \l_meend_true_int = 1
        \seq_map_variable:NNn \l_serial_seq \l_tmpa_int {
            \if_int_compare:w \int_mod:nn { \l_tmpa_int } { 2 } = 0
                \draw~[fill=black,draw=black] (\seq_item:Nn \l_meend_final_seq { \l_tmpa_int-1 }.south)~to~[out=315,in=225]~( \seq_item:Nn \l_meend_final_seq { \int_eval:n { \l_tmpa_int } }.south)~to~[out=215,in=325]~cycle;
            \fi:
         }
    \fi:
    
    \end{tikzpicture}
    \end{figure} 
}
\ExplSyntaxOff
