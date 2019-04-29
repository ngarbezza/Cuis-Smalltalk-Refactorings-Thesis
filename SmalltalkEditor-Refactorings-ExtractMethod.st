'From Cuis 5.0 of 7 November 2016 [latest update: #3719] on 29 April 2019 at 1:09:38 am'!


!SmalltalkEditor methodsFor: 'Refactorings-ExtractMethod' stamp: 'RNG 4/29/2019 01:06:57'!
extractMethod

	(ExtractMethod
		fromInterval: (self selectionInterval first to: self selectionInterval last + 1)
		of: self codeProvider selectedClassOrMetaClass >> self codeProvider selectedMessageName
		to: (FillInTheBlankMorph request: 'new method name:') asSymbol) apply! !
