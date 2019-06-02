'From Cuis 5.0 of 7 November 2016 [latest update: #3779] on 2 June 2019 at 7:23:02 pm'!
'Description Tests for the Extract Method refactoring.'!
!provides: 'Tests-Refactorings-ExtractMethod' 1 8!
!requires: 'Refactorings-ExtractMethod' 1 0 nil!
!requires: 'BaseImageTests' 1 149 nil!
SystemOrganization addCategory: #'Tests-Refactorings-ExtractMethod'!


!classDefinition: #ExtractMethodTest category: #'Tests-Refactorings-ExtractMethod'!
RefactoringTest subclass: #ExtractMethodTest
	instanceVariableNames: 'classToRefactor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Tests-Refactorings-ExtractMethod'!
!classDefinition: 'ExtractMethodTest class' category: #'Tests-Refactorings-ExtractMethod'!
ExtractMethodTest class
	instanceVariableNames: ''!


!ExtractMethodTest methodsFor: 'assertions' stamp: 'RNG 4/29/2019 00:30:56'!
assertClassHasDefined: newSelector withBody: newSourceCode

	self
		assert: (classToRefactor >> newSelector) sourceCode
		equals: newSourceCode! !

!ExtractMethodTest methodsFor: 'assertions' stamp: 'RNG 5/8/2019 23:34:49'!
assertClassHasDefined: newSelector withBody: newSourceCode inCategory: aCategory

	self assertClassHasDefined: newSelector withBody: newSourceCode.
	self assert: aCategory equals: (classToRefactor >> newSelector) category! !

!ExtractMethodTest methodsFor: 'assertions' stamp: 'RNG 5/12/2019 23:20:10'!
creationOnInterval: anIntervalToExtract failsWith: aRefactoringErrorMessage

	self
		creationWithSelectorNamed: #aValidSelector
		onInterval: anIntervalToExtract
		ofMethod: self methodToExtractCodeFrom
		failsWith: aRefactoringErrorMessage! !

!ExtractMethodTest methodsFor: 'assertions' stamp: 'RNG 5/12/2019 23:20:29'!
creationWithSelectorNamed: aSelectorName failsWith: aRefactoringErrorMessage

	self
		creationWithSelectorNamed: aSelectorName
		onInterval: self intervalToExtractFromMethod
		ofMethod: self methodToExtractCodeFrom
		failsWith: aRefactoringErrorMessage! !

!ExtractMethodTest methodsFor: 'assertions' stamp: 'RNG 5/12/2019 23:20:47'!
creationWithSelectorNamed: aSelectorName onInterval: anIntervalToExtract ofMethod: methodToExtractCodeFrom failsWith: aRefactoringErrorMessage

	self
		should: [
			ExtractMethod
				fromInterval: anIntervalToExtract
				of: methodToExtractCodeFrom
				to: aSelectorName
				categorizedAs: Categorizer default ]
		raise: Error - MessageNotUnderstood
		withMessageText: aRefactoringErrorMessage! !

!ExtractMethodTest methodsFor: 'class factory' stamp: 'RNG 4/20/2019 21:31:05'!
classToRefactorName

	^ #ClassToExtractMethod! !

!ExtractMethodTest methodsFor: 'method and source code helpers' stamp: 'RNG 5/12/2019 23:21:30'!
compileMethodToExtractCodeFrom

	classToRefactor compile: self sourceCodeOfMethodToExtractCodeFrom! !

!ExtractMethodTest methodsFor: 'method and source code helpers' stamp: 'RNG 5/28/2019 00:30:11'!
intervalToExtractFromMethod

	^ self intervalOfCode: '4'! !

!ExtractMethodTest methodsFor: 'method and source code helpers' stamp: 'RNG 5/12/2019 23:22:01'!
methodToExtractCodeFrom

	^ classToRefactor >> self selectorOfMethodToExtractCodeFrom! !

!ExtractMethodTest methodsFor: 'method and source code helpers' stamp: 'RNG 5/12/2019 23:25:05'!
selectorOfMethodToExtractCodeFrom

	^ #mExtractMethodExample:! !

!ExtractMethodTest methodsFor: 'method and source code helpers' stamp: 'RNG 6/2/2019 18:45:44'!
sourceCodeOfMethodToExtractCodeFrom

	^ self selectorOfMethodToExtractCodeFrom, ' anArgument

	<anAnnoyingPragma>
	| localVar |
	<anotherAnnoyingPragma>
	self m1.
	self m2: ''hey true''.
	self m3: anArgument , ''^ 21''.
	localVar := #($x $y $z) size.
	^ localVar + ((4))'! !

!ExtractMethodTest methodsFor: 'method and source code helpers' stamp: 'RNG 5/28/2019 00:36:15'!
updatedSourceCodeAfterExtracting: anInterval to: newSelector

	^ self sourceCodeOfMethodToExtractCodeFrom
		copyReplaceFrom: anInterval first
		to: anInterval last
		with: 'self ' , newSelector asString! !

!ExtractMethodTest methodsFor: 'method and source code helpers' stamp: 'RNG 5/28/2019 00:36:23'!
updatedSourceCodeAfterExtractingTo: newSelector

	^ self updatedSourceCodeAfterExtracting: self intervalToExtractFromMethod to: newSelector! !

!ExtractMethodTest methodsFor: 'refactoring helpers' stamp: 'RNG 5/13/2019 02:58:10'!
applyExtractMethodOf: anInterval to: newSelector on: aCategory 

	(ExtractMethod
		fromInterval: anInterval
		of: self methodToExtractCodeFrom
		to: newSelector
		categorizedAs: aCategory) apply! !

!ExtractMethodTest methodsFor: 'refactoring helpers' stamp: 'RNG 5/13/2019 02:58:43'!
applyExtractMethodTo: newSelector on: aCategory

	self
		applyExtractMethodOf: self intervalToExtractFromMethod
		to: newSelector
		on: aCategory! !

!ExtractMethodTest methodsFor: 'refactoring helpers' stamp: 'RNG 5/28/2019 00:32:05'!
intervalOfCode: aPieceOfSourceCode

	| interval |
	interval _ self sourceCodeOfMethodToExtractCodeFrom intervalOfSubCollection: aPieceOfSourceCode.
	^ interval first to: interval last - 1! !

!ExtractMethodTest methodsFor: 'set up' stamp: 'RNG 5/12/2019 23:21:15'!
setUp

	super setUp.
	classToRefactor _ self createClassNamed: self classToRefactorName.
	self compileMethodToExtractCodeFrom.! !

!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 5/12/2019 23:32:19'!
test09ExtractingALiteralCreatesANewMethodAndChangesExistingCodeToCallThatNewMethod

	| newSelector sourceCodeOfNewMethod originalSelector updatedSourceCodeOfOriginalMethod |
	newSelector _ #newMethod.
	sourceCodeOfNewMethod _ newSelector asString , '

	^ 4'.
	originalSelector _ self selectorOfMethodToExtractCodeFrom.
	updatedSourceCodeOfOriginalMethod _ self updatedSourceCodeAfterExtractingTo: newSelector.

	self applyExtractMethodTo: newSelector on: #category.

	self assertClassHasDefined: newSelector withBody: sourceCodeOfNewMethod inCategory: #category.
	self assertClassHasDefined: originalSelector withBody: updatedSourceCodeOfOriginalMethod! !

!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 5/28/2019 00:31:39'!
test15ExtractingAListOfStatementsCreatesANewMethodWithoutReturn

	| newSelector codeToExtract intervalToExtract sourceCodeOfNewMethod originalSelector updatedSourceCodeOfOriginalMethod |
	newSelector _ #newMethod.
	codeToExtract _
	'self m1.
	self m2: ''hey true'''.
	intervalToExtract _ self intervalOfCode: codeToExtract.
	sourceCodeOfNewMethod _ newSelector asString , '

	' , codeToExtract.
	originalSelector _ self selectorOfMethodToExtractCodeFrom.
	updatedSourceCodeOfOriginalMethod _ self updatedSourceCodeAfterExtracting: intervalToExtract to: newSelector.

	self applyExtractMethodOf: intervalToExtract to: newSelector on: #category.

	self assertClassHasDefined: newSelector withBody: sourceCodeOfNewMethod inCategory: #category.
	self assertClassHasDefined: originalSelector withBody: updatedSourceCodeOfOriginalMethod! !

!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 5/28/2019 00:31:52'!
test17AStringContainingTheReturnCharacterCanBeExtracted
	"this is to make sure the return is found using AST logic, not by text"

	| newSelector codeToExtract intervalToExtract sourceCodeOfNewMethod originalSelector updatedSourceCodeOfOriginalMethod |
	newSelector _ #newMethod.
	codeToExtract _
	'''^ 21'''.
	intervalToExtract _ self intervalOfCode: codeToExtract.
	sourceCodeOfNewMethod _ newSelector asString , '

	^ ' , codeToExtract.
	originalSelector _ self selectorOfMethodToExtractCodeFrom.
	updatedSourceCodeOfOriginalMethod _ self updatedSourceCodeAfterExtracting: intervalToExtract to: newSelector.

	self applyExtractMethodOf: intervalToExtract to: newSelector on: #category.

	self assertClassHasDefined: newSelector withBody: sourceCodeOfNewMethod inCategory: #category.
	self assertClassHasDefined: originalSelector withBody: updatedSourceCodeOfOriginalMethod! !

!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 6/2/2019 18:40:06'!
test18ExtractingAListOfStatementsIncludingDotsRemovesThemAndContinuesWithMethodExtraction

	| newSelector codeToExtract intervalToExtract actualIntervalToExtract sourceCodeOfNewMethod updatedSourceCodeOfOriginalMethod expectedExtractedCode |
	newSelector _ #newMethod.
	codeToExtract _
	'
	self m1.
	self m2: ''hey true''.'.
	expectedExtractedCode _ "trimmed initial enter and space, and ending dot"
	'self m1.
	self m2: ''hey true'''.
	intervalToExtract _ self intervalOfCode: codeToExtract.
	actualIntervalToExtract _ self intervalOfCode: expectedExtractedCode.
	updatedSourceCodeOfOriginalMethod _ self updatedSourceCodeAfterExtracting: actualIntervalToExtract to: newSelector.
	sourceCodeOfNewMethod _ newSelector asString , '

	' , expectedExtractedCode.

	self applyExtractMethodOf: intervalToExtract to: newSelector on: #category.

	self assertClassHasDefined: newSelector withBody: sourceCodeOfNewMethod inCategory: #category.
	self assertClassHasDefined: self selectorOfMethodToExtractCodeFrom withBody: updatedSourceCodeOfOriginalMethod! !

!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 6/2/2019 18:58:36'!
test19ASelectionContainingAdditionalParenthesesAtTheBeginningAndOrEndCanBeExtracted

	| newSelector codeToExtract intervalToExtract expectedIntervalToExtract sourceCodeOfNewMethod originalSelector updatedSourceCodeOfOriginalMethod |
	newSelector _ #newMethod.
	codeToExtract _ '((4))'.
	intervalToExtract _ self intervalOfCode: codeToExtract.
	expectedIntervalToExtract _ self intervalOfCode: '4'.
	sourceCodeOfNewMethod _ newSelector asString , '

	^ 4'.
	originalSelector _ self selectorOfMethodToExtractCodeFrom.
	updatedSourceCodeOfOriginalMethod _ self updatedSourceCodeAfterExtracting: expectedIntervalToExtract to: newSelector.

	self applyExtractMethodOf: intervalToExtract to: newSelector on: #category.

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

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 5/12/2019 23:22:01'!
test03NewSelectorShouldNotBeAlreadyDefinedInTheClass

	self
		creationWithSelectorNamed: self selectorOfMethodToExtractCodeFrom
		failsWith: ExtractMethodNewSelectorPrecondition newSelectorAlreadyDefinedOnTheClassErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 6/2/2019 19:17:39'!
test04NewSelectorShouldNotStartWithANumber

	self
		creationWithSelectorNamed: #'2selector'
		failsWith: ExtractMethodNewSelectorPrecondition invalidStartingCharacterOfNewSelectorErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 6/2/2019 19:22:36'!
test05NewUnarySelectorShouldNotStartWithASymbol

	self
		creationWithSelectorNamed: #-
		failsWith: ExtractMethodNewSelectorPrecondition invalidStartingCharacterOfNewSelectorErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 5/5/2019 12:20:04'!
test06IntervalToExtractIsNotBeforeMethodSourceCodeBoundaries

	self
		creationOnInterval: (-1 to: 2)
		failsWith: ExtractMethod outOfBoundsSelectionErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 5/12/2019 23:29:42'!
test07IntervalToExtractIsNotAfterMethodSourceCodeBoundaries

	self
		creationOnInterval: (1 to: self sourceCodeOfMethodToExtractCodeFrom size + 2)
		failsWith: ExtractMethod outOfBoundsSelectionErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 6/2/2019 18:59:22'!
test08IntervalToExtractShouldNotContainAReturnExpression

	self
		creationOnInterval: (self intervalOfCode: '^ localVar + ((4))')
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 6/2/2019 18:07:07'!
test10IntervalToExtractDoesNotContainsPartOfTheOriginalSelector

	| intervalToExtract |
	intervalToExtract  _ self intervalOfCode: self selectorOfMethodToExtractCodeFrom asString.
	self
		creationOnInterval: intervalToExtract
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 6/2/2019 18:06:21'!
test11IntervalToExtractDoesNotContainsPartOfLocalVariablesDefinition

	self
		creationOnInterval: (self intervalOfCode: '| localVar |')
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 6/2/2019 18:06:35'!
test12IntervalToExtractDoesNotContainsPartOfPragmasDefinition

	self
		creationOnInterval: (self intervalOfCode: '<anotherAnnoyingPragma>')
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 6/2/2019 18:59:26'!
test13IntervalToExtractShouldBeAValidSmalltalkExpression

	self
		creationOnInterval: (self intervalOfCode: '+ ((4))')
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 5/25/2019 21:16:38'!
test14ItIsNotPossibleToExtractTheLeftSideOfAnAssignment

	| firstOccurrence secondOccurrence intervalToExtract |
	firstOccurrence _ self sourceCodeOfMethodToExtractCodeFrom
		indexOfSubCollection: 'localVar' startingAt: 1.
	secondOccurrence _ self sourceCodeOfMethodToExtractCodeFrom
		indexOfSubCollection: 'localVar' startingAt: firstOccurrence + 1.
	intervalToExtract _ secondOccurrence toSelfPlus: 'localVar' size.
	self
		creationOnInterval: intervalToExtract
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 5/28/2019 00:27:43'!
test16CanNotExtractPartOfALiteral

	self
		creationOnInterval: (self intervalOfCode: 'true')
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !
