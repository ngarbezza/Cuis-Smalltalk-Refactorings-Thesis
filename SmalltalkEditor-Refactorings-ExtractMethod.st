'From Cuis 5.0 of 7 November 2016 [latest update: #3727] on 9 May 2019 at 12:10:38 am'!


!SmalltalkEditor methodsFor: 'Refactorings-ExtractMethod' stamp: 'RNG 5/9/2019 00:09:55'!
extractMethod

	[(ExtractMethod
		fromInterval: (self selectionInterval first to: self selectionInterval last + 1)
		of: self codeProvider currentCompiledMethod
		to: (FillInTheBlankMorph request: 'New method name:') asSymbol
		categorizedAs: Categorizer default) apply]
	on: RefactoringError do: [ :error | self inform: error messageText ]! !

!SmalltalkEditor methodsFor: 'Refactorings-ExtractMethod' stamp: 'RNG 5/9/2019 00:06:54'!
extractMethod: aKeyboardEvent

	self extractMethod.
	^true! !
