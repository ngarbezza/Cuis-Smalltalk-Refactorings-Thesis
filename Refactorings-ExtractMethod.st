!classDefinition: #ExtractMethodTest category: #'Refactorings-ExtractMethod'!
RefactoringTest subclass: #ExtractMethodTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Refactorings-ExtractMethod'!

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 4/18/2019 15:00:57'!
test01NewSelectorShouldNotBeEmpty

	| newSelector |
	newSelector _ ''.
	self
		creationWithSelectorNamed: newSelector
		failsWith: NewSelectorPrecondition newSelectorCanNotBeEmptyErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 4/18/2019 15:00:07'!
test02NewSelectorShouldNotContainSeparators

	| newSelector |
	newSelector _ 'my selector'.
	self
		creationWithSelectorNamed: newSelector
		failsWith: NewSelectorPrecondition newSelectorCanNotContainSeparatorsErrorMessage! !


!ExtractMethodTest methodsFor: 'refactor creation' stamp: 'RNG 4/18/2019 14:42:58'!
creationWithSelectorNamed: aSelectorName failsWith: aRefactoringErrorMessage 

	self
		should: [ ExtractMethod toSelector: aSelectorName ]
		raise: Error - MessageNotUnderstood
		withMessageText: aRefactoringErrorMessage! !


!classDefinition: #NewSelectorPreconditionTest category: #'Refactorings-ExtractMethod'!
TestCase subclass: #NewSelectorPreconditionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Refactorings-ExtractMethod'!

!NewSelectorPreconditionTest methodsFor: 'assertions' stamp: 'RNG 4/18/2019 15:05:10'!
assertPreconditionForSelector: selectorToValidate failsWith: preconditionFailedErrorMessage

	self
		should: [ NewSelectorPrecondition valueFor: selectorToValidate ]
		raise: Error - MessageNotUnderstood
		withMessageText: preconditionFailedErrorMessage! !


!NewSelectorPreconditionTest methodsFor: 'tests' stamp: 'RNG 4/18/2019 14:37:21'!
test01NewSelectorShouldNotBeEmpty

	self
		assertPreconditionForSelector: ''
		failsWith: NewSelectorPrecondition newSelectorCanNotBeEmptyErrorMessage! !

!NewSelectorPreconditionTest methodsFor: 'tests' stamp: 'RNG 4/18/2019 14:55:32'!
test02NewSelectorShouldNotContainSeparators

	self
		assertPreconditionForSelector: 'my selector'
		failsWith: NewSelectorPrecondition newSelectorCanNotContainSeparatorsErrorMessage! !


!classDefinition: #NewSelectorPrecondition category: #'Refactorings-ExtractMethod'!
RefactoringPrecondition subclass: #NewSelectorPrecondition
	instanceVariableNames: 'selectorToValidate'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Refactorings-ExtractMethod'!

!NewSelectorPrecondition methodsFor: 'evaluating' stamp: 'RNG 4/18/2019 15:13:07'!
value

	self
		assertNewSelectorIsNotEmpty;
		assertNewSelectorDoesNotContainSeparators! !


!NewSelectorPrecondition methodsFor: 'initialization' stamp: 'RNG 4/18/2019 15:02:59'!
initializeFor: aSelectorToValidate

	selectorToValidate _ aSelectorToValidate! !


!NewSelectorPrecondition methodsFor: 'exceptions' stamp: 'RNG 4/18/2019 15:11:55'!
signalNewSelectorCanNotBeEmptyError

	self refactoringError: self class newSelectorCanNotBeEmptyErrorMessage! !

!NewSelectorPrecondition methodsFor: 'exceptions' stamp: 'RNG 4/18/2019 15:13:59'!
signalNewSelectorCanNotContainSeparatorsError

	self error: self class newSelectorCanNotContainSeparatorsErrorMessage! !


!NewSelectorPrecondition methodsFor: 'evaluating - private' stamp: 'RNG 4/18/2019 15:13:52'!
assertNewSelectorDoesNotContainSeparators

	(selectorToValidate anySatisfy: [ :character | character isSeparator ])
		ifTrue: [ self signalNewSelectorCanNotContainSeparatorsError ]! !

!NewSelectorPrecondition methodsFor: 'evaluating - private' stamp: 'RNG 4/18/2019 15:11:46'!
assertNewSelectorIsNotEmpty

	selectorToValidate ifEmpty: [ self signalNewSelectorCanNotBeEmptyError ].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NewSelectorPrecondition class' category: #'Refactorings-ExtractMethod'!
NewSelectorPrecondition class
	instanceVariableNames: ''!

!NewSelectorPrecondition class methodsFor: 'error messages' stamp: 'RNG 4/18/2019 14:40:21'!
newSelectorCanNotBeEmptyErrorMessage

	^ 'New selector can not be empty'! !

!NewSelectorPrecondition class methodsFor: 'error messages' stamp: 'RNG 4/18/2019 15:05:41'!
newSelectorCanNotContainSeparatorsErrorMessage

	^ 'New selector can not contain separators'! !


!NewSelectorPrecondition class methodsFor: 'instance creation' stamp: 'RNG 4/18/2019 15:02:33'!
for: selectorToValidate

	^ self new initializeFor: selectorToValidate! !


!NewSelectorPrecondition class methodsFor: 'evaluating' stamp: 'RNG 4/18/2019 15:02:10'!
valueFor: selectorToValidate

	^ (self for: selectorToValidate) value! !


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

!ExtractMethod class methodsFor: 'instance creation' stamp: 'RNG 4/18/2019 10:35:37'!
toSelector: newSelector

	self ensureIsValidSelector: newSelector! !


!ExtractMethod class methodsFor: 'validations' stamp: 'RNG 4/18/2019 15:01:37'!
ensureIsValidSelector: aSelector

	NewSelectorPrecondition valueFor: aSelector! !
