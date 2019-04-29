'From Cuis 5.0 of 7 November 2016 [latest update: #3719] on 29 April 2019 at 1:11:27 am'!


!RefactoringMenues class methodsFor: 'editor menus' stamp: 'RNG 4/20/2019 21:09:55'!
smalltalkEditorMenuOptions

	^`{
		{
				#itemGroup 		-> 		35.
				#itemOrder 		-> 		10.
				#label 			-> 		'Rename... (R)'.
				#selector 		-> 		#contextualRename.
				#icon 			-> 		#saveAsIcon
		} asDictionary.
		{
				#itemGroup 		-> 		35.
				#itemOrder 		-> 		20.
				#label 			-> 		'Extract Method... (X)'.
				#selector 		-> 		#extractMethod.
				#icon 			-> 		#saveAsIcon
		} asDictionary
	}`! !
