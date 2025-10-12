-- use vimtex to determine if we are in a math context
local function math()
    return vim.api.nvim_eval('vimtex#syntax#in_mathzone()') == 1
end 

return {
	s({trig=";a", snippetType="autosnippet", desc="alpha",wordTrig=false},
	    {t("\\alpha"),}
	),
	s({trig="\"", snippetType="autosnippet", desc="quotation marks"},
		fmta(
    	    [[``<>'' ]],
    	    {i(1, "quoted text"),}
    	)
	),
	s({trig="fig", snippetType="snippet", dscr="A basic figure environment"},
	    fmta(
	        [[
	        \begin{figure}
	        \centering
	        \includegraphics[width=0.9\linewidth]{<>}
	        \caption{
	            \textbf{<>}
	            <>
	            }
	        \label{fig:<>}
	        \end{figure}
	
	        ]],
	        { i(1,"filename"),
	          i(2, "captionBold"),
	          i(3, "captionText"),
	          i(4,"figureLabel"),}
	    )
	),
	s({trig="env", snippetType="snippet", dscr="Begin and end an arbitrary environment"},
	    fmta(
	        [[
	        \begin{<>}
	            <>
	        \end{<>}
	        ]],
	        {i(1),i(2),rep(1),}
	    )
	),
	--postfixes for vectors, hats, etc. The match pattern is '\\' plus the default (so that hats get put on greek letters,e.g.)
	postfix({trig="hat", match_pattern = [[[\\%w%.%_%-%"%']+$]], snippetType="autosnippet",dscr="postfix hat when in math mode"},
	    {l("\\hat{" .. l.POSTFIX_MATCH .. "}")}, 
	    { condition=math }
	) ,
	postfix({trig="vec", match_pattern = [[[\\%w%.%_%-%"%']+$]] ,snippetType="autosnippet",dscr="postfix vec when in math mode"},
	    {l("\\vec{" .. l.POSTFIX_MATCH .. "}")}, 
	    { condition=math }
	),
	s({ trig = "textbf", desc = "Wrap selected text with \\textbf{}" },
	    f(function(_, snip)
	        local res, env = {}, snip.env
	        for _, ele in ipairs(env.LS_SELECT_RAW) do
	            table.insert(res, "\\textbf{" .. ele .. "}")
	        end
	        return res
	    end, {})
	)
}
