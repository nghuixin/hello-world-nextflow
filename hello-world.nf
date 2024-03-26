params.output_file = 'output.txt'

process sayHello {
	input:
		val greeting
		val lang
	
    	output:
        	path "${lang}-${params.output_file}"

	"""
	echo '$greeting' > '$lang-$params.output_file' 
	"""  
}

process toUpper {
   	
	input: 
		path input_file
		
   	output: 
		path "upper-${input_file}"

	"""
	cat $input_file | tr '[a-z]' '[A-Z]' > upper-${input_file}
	"""
}

workflow {
	//greeting_ch = Channel.of(params.greeting)
	greeting_ch = Channel.fromPath(params.input_file).splitText() { it.trim() }
	//	lang_ch = Channel.of(params.lang)
	lang_ch = Channel.fromPath(params.lang_file).splitText() {it.trim()}
	sayHello(greeting_ch, lang_ch)

	toUpper(sayHello.out)
}
