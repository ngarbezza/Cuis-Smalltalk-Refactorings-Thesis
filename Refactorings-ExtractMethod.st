!classDefinition: #ExtractMethodTest category: #'Refactorings-ExtractMethod'!
RefactoringTest subclass: #ExtractMethodTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Refactorings-ExtractMethod'!

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 4/18/2019 10:31:08'!
test01NewSelectorShouldNotBeEmpty

	| newSelector |
	newSelector _ ''.
	self
		creationWithSelectorNamed: newSelector
		failsWith: ExtractMethod selectorCanNotBeEmptyErrorMessage! !


!ExtractMethodTest methodsFor: 'refactor creation' stamp: 'RNG 4/18/2019 10:34:46'!
creationWithSelectorNamed: aSelectorName failsWith: anErrorMessage 

	self
		should: [ ExtractMethod toSelector: aSelectorName ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :error | self assert: error messageText equals: anErrorMessage ]! !


!classDefinition: #ExtractMethod category: #'Refactorings-ExtractMethod'!
Object subclass: #ExtractMethod
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Refactorings-ExtractMethod'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ExtractMethod class' category: #'Refactorings-ExtractMethod'!
ExtractMethod class
	instanceVariableNames: ''!

!ExtractMethod class methodsFor: 'error messages' stamp: 'RNG 4/18/2019 10:31:47'!
selectorCanNotBeEmptyErrorMessage
	
	^ 'selector cannot be empty'! !


!ExtractMethod class methodsFor: 'instance creation' stamp: 'RNG 4/18/2019 10:35:37'!
toSelector: newSelector

	self ensureIsValidSelector: newSelector! !


!ExtractMethod class methodsFor: 'validations' stamp: 'RNG 4/18/2019 10:36:02'!
ensureIsValidSelector: aSelector

	self error: self selectorCanNotBeEmptyErrorMessage! !
