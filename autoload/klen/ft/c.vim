" Library of functions for the c file type.
"
" 2021 Dec 16 - Written by Kenny Lam.

" Comment out lines selected in Visual mode if the first of such lines is not
" commented. Otherwise, uncomment them.
function klen#ft#c#v_toggle_comment() range
	" klen#ft#c#v_toggle_comment() implementation {{{
	let l:save_search = getreg('/')
	let l:range = a:firstline .. ',' .. a:lastline
	let l:xrange = (a:firstline + 1) .. ',' .. (a:lastline - 1)
	if getline(a:firstline) =~ '\v^\s*%(/\*|\*)'
		" First line is a comment: uncomment selected lines.
		if a:firstline == a:lastline
			execute a:firstline .. 's`\v^\s*\zs%(/\* ?| \* ?)``'
			execute a:firstline .. 's`\v\s*\*/\s*$``e'
		else
			execute l:range .. 's`\v^\s*\zs%(/\* ?| \*/| \* ?)``e'
		endif
	elseif a:firstline == a:lastline
		" Comment the one selected line.
		execute a:firstline .. 's`\v^`/\* `'
		execute a:firstline .. 's`\v$` \*/`'
	else
		" Comment selected lines.
		execute a:firstline .. 's`\v^`/\* `'
		if a:firstline + 1 <= a:lastline - 1
			execute l:xrange .. 's`\v^%(/\* | \* )?` \* `'
		endif
		if getline(a:lastline) =~ '\v^\s*%(\*/)?\s*$'
			call setline(a:lastline, ' */')
		else
			execute a:lastline .. 's`\v^%(/\* | \* )?` \* `'
			let l:next_line = a:lastline + 1
			if l:next_line <= line('$')
			 \ && getline(l:next_line) =~ '\v^\s*%(\*/)?\s*$'
				call setline(l:next_line, ' */')
			else
				call append(a:lastline, ' */')
			endif
			let l:save_vstart = getpos("'<")
			let l:vend = getpos("'>")
			let l:vend[1] += 1
			call setpos("'>", l:vend)
			call setpos("'<", l:save_vstart)
		endif
	endif
	nohlsearch
	call setreg('/', l:save_search)
endfunction
" }}}
