// Defining a process named 'sayHello'
process sayHello {
        // Input definitions for the process
        input:
                val greeting // Declares a variable 'greeting' as input
                val lang // Declares a variable 'lang' as input

        // Output definition for the process
        output:
                path "${lang}-${params.output_file}" // Specifies the output file path, dynamically named using the lang variable and a parameter

        // The script block of the process
        """
        echo '$greeting' > '$lang-$params.output_file' # Writes the greeting variable content into a file named using lang and params.output_file
        """
}

// Defining another process named 'toUpper'
process toUpper {

        // Input definitions for this process
        input:
                path input_file // Declares 'input_file' as an input path

        // Output definitions for this process
        output:
                path "upper-${input_file}" // Specifies the output file path, prefixed with 'upper-'

        // The script block of the process
        """
        cat $input_file | tr '[a-z]' '[A-Z]' > upper-${input_file} # Converts all lowercase letters to uppercase and writes to a new file
        """
}

// Defining a workflow block
workflow {
        // Creates a channel from a file specified in 'params.input_file' and splits its text into items
        greeting_ch = Channel.fromPath(params.input_file).splitText() { it.trim() } 

        // Creates another channel from a file specified in 'params.lang_file' and splits its text into items
        lang_ch = Channel.fromPath(params.lang_file).splitText() { it.trim() }

        // Invokes the 'sayHello' process with the two channels 'greeting_ch' and 'lang_ch' as input
        sayHello(greeting_ch, lang_ch)

        // Invokes the 'toUpper' process with the output of 'sayHello' process as input
        toUpper(sayHello.out)
}

