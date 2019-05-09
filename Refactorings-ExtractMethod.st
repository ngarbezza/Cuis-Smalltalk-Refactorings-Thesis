!classDefinition: #ExtractMethodTest category: #'Refactorings-ExtractMethod'!
RefactoringTest subclass: #ExtractMethodTest
	instanceVariableNames: 'classToRefactor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Refactorings-ExtractMethod'!

!ExtractMethodTest methodsFor: 'assertions' stamp: 'RNG 4/29/2019 00:30:56'!
assertClassHasDefined: newSelector withBody: newSourceCode

	self
		assert: (classToRefactor >> newSelector) sourceCode
		equals: newSourceCode! !

!ExtractMethodTest methodsFor: 'assertions' stamp: 'RNG 5/8/2019 23:34:49'!
assertClassHasDefined: newSelector withBody: newSourceCode inCategory: aCategory

	self assertClassHasDefined: newSelector withBody: newSourceCode.
	self assert: aCategory equals: (classToRefactor >> newSelector) category! !

!ExtractMethodTest methodsFor: 'assertions' stamp: 'RNG 4/21/2019 21:54:54'!
creationOnInterval: anIntervalToExtract failsWith: aRefactoringErrorMessage

	self
		creationWithSelectorNamed: #aValidSelector
		onInterval: anIntervalToExtract
		ofMethod: self methodWithOneLiteral
		failsWith: aRefactoringErrorMessage! !

!ExtractMethodTest methodsFor: 'assertions' stamp: 'RNG 4/21/2019 11:15:36'!
creationWithSelectorNamed: aSelectorName failsWith: aRefactoringErrorMessage

	self
		creationWithSelectorNamed: aSelectorName
		onInterval: self intervalToExtractFromMethodWithOneLiteral
		ofMethod: self methodWithOneLiteral
		failsWith: aRefactoringErrorMessage! !

!ExtractMethodTest methodsFor: 'assertions' stamp: 'RNG 5/8/2019 23:37:37'!
creationWithSelectorNamed: aSelectorName onInterval: anIntervalToExtract ofMethod: methodToExtractCodeFrom failsWith: aRefactoringErrorMessage

	self
		should: [
			ExtractMethod
				fromInterval: anIntervalToExtract
				of: methodToExtractCodeFrom
				to: aSelectorName categorizedAs: aCategory ]
		raise: Error - MessageNotUnderstood
		withMessageText: aRefactoringErrorMessage! !


!ExtractMethodTest methodsFor: 'class factory' stamp: 'RNG 4/20/2019 21:31:05'!
classToRefactorName

	^ #ClassToExtractMethod! !


!ExtractMethodTest methodsFor: 'method factory' stamp: 'RNG 4/28/2019 23:39:37'!
compileMethodWithOneLiteral

	classToRefactor compile: self sourceCodeOfMethodWithOneLiteral! !

!ExtractMethodTest methodsFor: 'method factory' stamp: 'RNG 4/28/2019 23:39:52'!
intervalToExtractFromMethodWithOneLiteral

	^ self sourceCodeOfMethodWithOneLiteral intervalOfSubCollection: '4'! !

!ExtractMethodTest methodsFor: 'method factory' stamp: 'RNG 4/21/2019 11:12:54'!
methodWithOneLiteral

	^ classToRefactor >> self selectorOfMethodWithOneLiteral! !

!ExtractMethodTest methodsFor: 'method factory' stamp: 'RNG 4/21/2019 11:12:36'!
selectorOfMethodWithOneLiteral

	^ #m1OneLiteral! !

!ExtractMethodTest methodsFor: 'method factory' stamp: 'RNG 4/28/2019 23:39:24'!
sourceCodeOfMethodWithOneLiteral

	| sourceCodeToExtract |
	sourceCodeToExtract _ '4'.
	^ self selectorOfMethodWithOneLiteral asString , ' ^ ' , sourceCodeToExtract! !


!ExtractMethodTest methodsFor: 'refactoring helpers' stamp: 'RNG 5/8/2019 23:37:49'!
extractLiteralTo: newSelector on: aCategory 

	(ExtractMethod
		fromInterval: self intervalToExtractFromMethodWithOneLiteral
		of: self methodWithOneLiteral
		to: newSelector
		categorizedAs: aCategory) apply! !


!ExtractMethodTest methodsFor: 'set up' stamp: 'RNG 4/21/2019 11:15:40'!
setUp

	super setUp.
	classToRefactor _ self createClassNamed: self classToRefactorName.
	self compileMethodWithOneLiteral.! !


!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 5/8/2019 23:30:20'!
test09ExtractingALiteralCreatesANewMethodAndChangesExistingCodeToCallThatNewMethod

	| newSelector sourceCodeOfNewMethod originalSelector updatedSourceCodeOfOriginalMethod |
	newSelector _ #newMethod.
	sourceCodeOfNewMethod _ newSelector asString , '

	^ 4'.
	originalSelector _ self selectorOfMethodWithOneLiteral.
	updatedSourceCodeOfOriginalMethod _ originalSelector , ' ^ self ' , newSelector asString.

	self extractLiteralTo: newSelector on: #category.

	self assertClassHasDefined: newSelector withBody: sourceCodeOfNewMethod inCategory: #category.
	self assertClassHasDefined: originalSelector withBody: updatedSourceCodeOfOriginalMethod! !


!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 5/4/2019 22:40:07'!
test01NewSelectorShouldNotBeEmpty

	self
		creationWithSelectorNamed: #''
		failsWith: ExtractMethodNewSelectorPrecondition newSelectorCanNotBeEmptyErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 5/4/2019 22:40:07'!
test02NewSelectorShouldNotContainSeparators

	self
		creationWithSelectorNamed: #'my selector'
		failsWith: ExtractMethodNewSelectorPrecondition newSelectorCanNotContainSeparatorsErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 5/4/2019 22:40:07'!
test03NewSelectorShouldNotBeAlreadyDefinedInTheClass

	self
		creationWithSelectorNamed: self selectorOfMethodWithOneLiteral
		failsWith: ExtractMethodNewSelectorPrecondition newSelectorAlreadyDefinedOnTheClassErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 5/5/2019 12:19:39'!
test04NewSelectorShouldNotStartWithANumber

	self
		creationWithSelectorNamed: #'2selector'
		failsWith: ExtractMethodNewSelectorPrecondition newSelectorCanNotStartWithANumberErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 5/5/2019 12:19:49'!
test05NewSelectorShouldNotStartWithAnUppercaseLetter

	self
		creationWithSelectorNamed: #TheSelector
		failsWith: ExtractMethodNewSelectorPrecondition newSelectorCanNotStartWithAnUppercaseLetterErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 5/5/2019 12:20:04'!
test06IntervalToExtractIsNotBeforeMethodSourceCodeBoundaries

	self
		creationOnInterval: (-1 to: 2)
		failsWith: ExtractMethod outOfBoundsSelectionErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 5/5/2019 12:20:20'!
test07IntervalToExtractIsNotAfterMethodSourceCodeBoundaries

	self
		creationOnInterval: (1 to: 22)
		failsWith: ExtractMethod outOfBoundsSelectionErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 5/5/2019 12:20:29'!
test08IntervalToExtractShouldNotContainAReturnExpression

	| intervalToExtract |
	intervalToExtract  _ self sourceCodeOfMethodWithOneLiteral intervalOfSubCollection: '^ 4'.
	self
		creationOnInterval: intervalToExtract
		failsWith: ExtractMethod returnInSourceToExtractErrorMessage! !


!classDefinition: #ExtractMethod category: #'Refactorings-ExtractMethod'!
Refactoring subclass: #ExtractMethod
	instanceVariableNames: 'intervalToExtract sourceMethod newSelector categoryOfNewSelector'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Refactorings-ExtractMethod'!

!ExtractMethod methodsFor: 'initialization' stamp: 'RNG 5/8/2019 23:39:59'!
initializeFrom: anIntervalToExtract of: aMethodToExtractCodeFrom to: aNewSelector in: aCategory 

	intervalToExtract _ anIntervalToExtract.
	sourceMethod _ aMethodToExtractCodeFrom.
	newSelector _ aNewSelector.
	categoryOfNewSelector _ aCategory! !


!ExtractMethod methodsFor: 'applying' stamp: 'RNG 4/29/2019 00:45:18'!
apply

	self
		defineExtractedMethod;
		changeExistingMethod! !

!ExtractMethod methodsFor: 'applying' stamp: 'RNG 5/8/2019 23:34:19'!
changeExistingMethod

	sourceMethod methodClass
		compile: self updatedSourceCodeOfExistingMethod
		classified: sourceMethod category! !

!ExtractMethod methodsFor: 'applying' stamp: 'RNG 5/8/2019 23:40:24'!
defineExtractedMethod

 	sourceMethod methodClass
		compile: self newMethodSourceCode
		classified: categoryOfNewSelector! !


!ExtractMethod methodsFor: 'source code' stamp: 'RNG 5/7/2019 00:14:58'!
newMethodSourceCode

	| extractedSource |
	extractedSource _ sourceMethod sourceCode copyFrom: intervalToExtract first to: intervalToExtract last - 1.
	^ newSelector asString , String lfString , String lfString , String tab , '^ ' , extractedSource! !

!ExtractMethod methodsFor: 'source code' stamp: 'RNG 5/7/2019 00:12:04'!
updatedSourceCodeOfExistingMethod

	^ sourceMethod sourceCode
		copyReplaceFrom: intervalToExtract first
		to: intervalToExtract last - 1
		with: 'self ', newSelector asString! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ExtractMethod class' category: #'Refactorings-ExtractMethod'!
ExtractMethod class
	instanceVariableNames: ''!

!ExtractMethod class methodsFor: 'instance creation' stamp: 'RNG 5/8/2019 23:39:31'!
fromInterval: anIntervalToExtract of: aMethodToExtractCodeFrom to: aNewSelector categorizedAs: aCategory 

	self
		ensure: aNewSelector canBeDefinedIn: aMethodToExtractCodeFrom methodClass;
		ensure: anIntervalToExtract isValidIntervalOn: aMethodToExtractCodeFrom.

	^ self new
		initializeFrom: anIntervalToExtract
		of: aMethodToExtractCodeFrom
		to: aNewSelector
		in: aCategory! !


!ExtractMethod class methodsFor: 'validations' stamp: 'RNG 5/4/2019 22:40:07'!
ensure: aSelector canBeDefinedIn: aClass 

	ExtractMethodNewSelectorPrecondition valueFor: aSelector on: aClass! !

!ExtractMethod class methodsFor: 'validations' stamp: 'RNG 4/29/2019 00:22:51'!
ensure: anIntervalToExtract isValidIntervalOn: aMethodToExtractCodeFrom 

	(self is: anIntervalToExtract withinBoundsOf: aMethodToExtractCodeFrom sourceCode)
		ifFalse: [ self signalOutOfBoundsIntervalError ].
	(self containsAReturnExpression: aMethodToExtractCodeFrom sourceCode onInterval: anIntervalToExtract)
		ifTrue: [ self signalReturnInSourceToExtractError ]! !


!ExtractMethod class methodsFor: 'error messages' stamp: 'RNG 4/20/2019 21:53:45'!
outOfBoundsSelectionErrorMessage

	^ 'The source code selection interval is out of bounds'! !

!ExtractMethod class methodsFor: 'error messages' stamp: 'RNG 4/28/2019 23:49:05'!
returnInSourceToExtractErrorMessage

	^ 'Can not extract this piece of code: there is a return expression'! !


!ExtractMethod class methodsFor: 'exceptions' stamp: 'RNG 4/20/2019 21:53:24'!
signalOutOfBoundsIntervalError

	self refactoringError: self outOfBoundsSelectionErrorMessage! !

!ExtractMethod class methodsFor: 'exceptions' stamp: 'RNG 4/28/2019 23:55:45'!
signalReturnInSourceToExtractError

	self refactoringError: self returnInSourceToExtractErrorMessage! !


!ExtractMethod class methodsFor: 'validations - private' stamp: 'RNG 4/29/2019 00:25:20'!
containsAReturnExpression: aSourceCode onInterval: anIntervalToExtract 

	^ (aSourceCode copyFrom: anIntervalToExtract first to: anIntervalToExtract last - 1) includes: $^! !

!ExtractMethod class methodsFor: 'validations - private' stamp: 'RNG 4/28/2019 23:52:09'!
is: anIntervalToExtract withinBoundsOf: aSourceCode

	^ anIntervalToExtract first >= 1 and: [ anIntervalToExtract last - 1 <= aSourceCode size ]! !


!classDefinition: #ExtractMethodNewSelectorPrecondition category: #'Refactorings-ExtractMethod'!
RefactoringPrecondition subclass: #ExtractMethodNewSelectorPrecondition
	instanceVariableNames: 'selectorToValidate classToDefineSelector'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Refactorings-ExtractMethod'!

!ExtractMethodNewSelectorPrecondition methodsFor: 'evaluating' stamp: 'RNG 4/18/2019 16:02:13'!
value

	self
		assertNewSelectorIsNotEmpty;
		assertNewSelectorDoesNotContainSeparators;
		assertNewSelectorDoesNotStartWithANumber;
		assertNewSelectorDoesNotStartWithAnUppercaseLetter;
		assertNewSelectorIsNotAlreadyDefinedInTheClass! !


!ExtractMethodNewSelectorPrecondition methodsFor: 'initialization' stamp: 'RNG 4/18/2019 16:04:44'!
initializeFor: aSelectorToValidate on: aClassToDefineSelector

	selectorToValidate _ aSelectorToValidate.
	classToDefineSelector _ aClassToDefineSelector! !


!ExtractMethodNewSelectorPrecondition methodsFor: 'exceptions' stamp: 'RNG 4/18/2019 15:11:55'!
signalNewSelectorCanNotBeEmptyError

	self refactoringError: self class newSelectorCanNotBeEmptyErrorMessage! !

!ExtractMethodNewSelectorPrecondition methodsFor: 'exceptions' stamp: 'RNG 5/5/2019 12:22:02'!
signalNewSelectorCanNotContainSeparatorsError

	self refactoringError: self class newSelectorCanNotContainSeparatorsErrorMessage! !

!ExtractMethodNewSelectorPrecondition methodsFor: 'exceptions' stamp: 'RNG 5/5/2019 12:22:34'!
signalNewSelectorCanNotStartWithANumberError

	self refactoringError: self class newSelectorCanNotStartWithANumberErrorMessage! !

!ExtractMethodNewSelectorPrecondition methodsFor: 'exceptions' stamp: 'RNG 4/18/2019 15:41:13'!
signalNewSelectorCanNotStartWithAnUppercaseLetterError

	self refactoringError: self class newSelectorCanNotStartWithAnUppercaseLetterErrorMessage! !

!ExtractMethodNewSelectorPrecondition methodsFor: 'exceptions' stamp: 'RNG 5/5/2019 12:22:40'!
signalNewSelectorIsAlreadyDefinedInTheClassError

	self refactoringError: self class newSelectorAlreadyDefinedOnTheClassErrorMessage! !


!ExtractMethodNewSelectorPrecondition methodsFor: 'evaluating - private' stamp: 'RNG 4/18/2019 15:13:52'!
assertNewSelectorDoesNotContainSeparators

	(selectorToValidate anySatisfy: [ :character | character isSeparator ])
		ifTrue: [ self signalNewSelectorCanNotContainSeparatorsError ]! !

!ExtractMethodNewSelectorPrecondition methodsFor: 'evaluating - private' stamp: 'RNG 5/5/2019 12:23:28'!
assertNewSelectorDoesNotStartWithANumber

	selectorToValidate first isDigit
		ifTrue: [ self signalNewSelectorCanNotStartWithANumberError ]! !

!ExtractMethodNewSelectorPrecondition methodsFor: 'evaluating - private' stamp: 'RNG 5/5/2019 12:23:23'!
assertNewSelectorDoesNotStartWithAnUppercaseLetter
	
	selectorToValidate first isUppercase
		ifTrue: [ self signalNewSelectorCanNotStartWithAnUppercaseLetterError ]! !

!ExtractMethodNewSelectorPrecondition methodsFor: 'evaluating - private' stamp: 'RNG 5/5/2019 12:23:12'!
assertNewSelectorIsNotAlreadyDefinedInTheClass

	(classToDefineSelector includesSelector: selectorToValidate)
		ifTrue: [ self signalNewSelectorIsAlreadyDefinedInTheClassError ]! !

!ExtractMethodNewSelectorPrecondition methodsFor: 'evaluating - private' stamp: 'RNG 5/5/2019 12:23:16'!
assertNewSelectorIsNotEmpty

	selectorToValidate ifEmpty: [ self signalNewSelectorCanNotBeEmptyError ]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ExtractMethodNewSelectorPrecondition class' category: #'Refactorings-ExtractMethod'!
ExtractMethodNewSelectorPrecondition class
	instanceVariableNames: ''!

!ExtractMethodNewSelectorPrecondition class methodsFor: 'error messages' stamp: 'RNG 4/18/2019 15:58:58'!
newSelectorAlreadyDefinedOnTheClassErrorMessage

	^ 'New selector is already defined on this class'! !

!ExtractMethodNewSelectorPrecondition class methodsFor: 'error messages' stamp: 'RNG 4/18/2019 14:40:21'!
newSelectorCanNotBeEmptyErrorMessage

	^ 'New selector can not be empty'! !

!ExtractMethodNewSelectorPrecondition class methodsFor: 'error messages' stamp: 'RNG 4/18/2019 15:05:41'!
newSelectorCanNotContainSeparatorsErrorMessage

	^ 'New selector can not contain separators'! !

!ExtractMethodNewSelectorPrecondition class methodsFor: 'error messages' stamp: 'RNG 4/18/2019 15:34:30'!
newSelectorCanNotStartWithANumberErrorMessage

	^ 'New selector can not start with a number'! !

!ExtractMethodNewSelectorPrecondition class methodsFor: 'error messages' stamp: 'RNG 4/18/2019 15:41:13'!
newSelectorCanNotStartWithAnUppercaseLetterErrorMessage

	^ 'New selector can not start with an uppercase letter'! !


!ExtractMethodNewSelectorPrecondition class methodsFor: 'instance creation' stamp: 'RNG 4/18/2019 16:01:43'!
for: aSelectorToValidate on: aClass 

	^ self new initializeFor: aSelectorToValidate on: aClass! !


!ExtractMethodNewSelectorPrecondition class methodsFor: 'evaluating' stamp: 'RNG 4/18/2019 15:59:44'!
valueFor: aSelectorToValidate on: aClass

	^ (self for: aSelectorToValidate on: aClass) value! !
