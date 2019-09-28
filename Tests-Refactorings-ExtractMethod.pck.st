'From Cuis 5.0 [latest update: #3880] on 27 September 2019 at 11:56:51 pm'!
'Description Tests for the Extract Method refactoring.'!
!provides: 'Tests-Refactorings-ExtractMethod' 1 15!
!requires: 'Refactorings-ExtractMethod' 1 0 nil!
!requires: 'BaseImageTests' 1 149 nil!
SystemOrganization addCategory: #'Tests-Refactorings-ExtractMethod'!


!classDefinition: #ExtractMethodTest category: #'Tests-Refactorings-ExtractMethod'!
RefactoringTest subclass: #ExtractMethodTest
	instanceVariableNames: 'classToRefactor newUnaryMessage newUnarySelector'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Tests-Refactorings-ExtractMethod'!
!classDefinition: 'ExtractMethodTest class' category: #'Tests-Refactorings-ExtractMethod'!
ExtractMethodTest class
	instanceVariableNames: ''!


!ExtractMethodTest methodsFor: 'assertions' stamp: 'RNG 6/23/2019 18:30:13'!
assertClassHasDefined: aSelector withBody: newSourceCode

	self
		assert: (classToRefactor >> aSelector) sourceCode
		equals: newSourceCode! !

!ExtractMethodTest methodsFor: 'assertions' stamp: 'RNG 6/23/2019 18:30:02'!
assertClassHasDefined: aSelector withBody: newSourceCode inCategory: aCategory

	self assertClassHasDefined: aSelector withBody: newSourceCode.
	self assert: aCategory equals: (classToRefactor >> aSelector) category! !

!ExtractMethodTest methodsFor: 'assertions' stamp: 'RNG 6/23/2019 18:21:38'!
creationWithSelectorNamed: aSelectorName onInterval: anIntervalToExtract ofMethod: methodToExtractCodeFrom failsWith: aRefactoringErrorMessage

	self
		should: [
			ExtractMethod
				fromInterval: anIntervalToExtract
				of: methodToExtractCodeFrom
				to: (Message selector: aSelectorName)
				categorizedAs: Categorizer default ]
		raise: Error - MessageNotUnderstood
		withMessageText: aRefactoringErrorMessage! !

!ExtractMethodTest methodsFor: 'assertions' stamp: 'RNG 9/27/2019 23:38:21'!
extract: codeToExtract from: originalCode withSelector: newSelector defines: newCode andUpdates: updatedCode

	| originalSelector category |
	category _ #category.
	originalSelector _ classToRefactor compile: originalCode classified: category.

	(ExtractMethod
		fromInterval: (self intervalOf: codeToExtract locatedIn: originalCode)
		of: classToRefactor >> originalSelector
		to: (Message selector: newSelector)
		categorizedAs: category) apply.

	self
		assertClassHasDefined: originalSelector withBody: updatedCode inCategory: category;
		assertClassHasDefined: newSelector withBody: newCode inCategory: category! !

!ExtractMethodTest methodsFor: 'assertions' stamp: 'RNG 9/22/2019 22:30:00'!
tryingToExtractOnInterval: anIntervalToExtract failsWith: aRefactoringErrorMessage

	self
		creationWithSelectorNamed: #aValidSelector
		onInterval: anIntervalToExtract
		ofMethod: self methodToExtractCodeFrom
		failsWith: aRefactoringErrorMessage! !

!ExtractMethodTest methodsFor: 'assertions' stamp: 'RNG 9/22/2019 22:29:34'!
tryingToExtractWithSelectorNamed: aSelectorName failsWith: aRefactoringErrorMessage

	self
		creationWithSelectorNamed: aSelectorName
		onInterval: self intervalToExtractFromMethod
		ofMethod: self methodToExtractCodeFrom
		failsWith: aRefactoringErrorMessage! !

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

!ExtractMethodTest methodsFor: 'method and source code helpers' stamp: 'RNG 6/23/2019 19:49:14'!
newMethodDefinitionOf: newMessage including: newSourceCode

	^ newMessage fullName , '

	' , newSourceCode! !

!ExtractMethodTest methodsFor: 'method and source code helpers' stamp: 'RNG 6/23/2019 19:49:31'!
newMethodDefinitionWith: newSourceCode

	^ self newMethodDefinitionOf: newUnaryMessage including: newSourceCode! !

!ExtractMethodTest methodsFor: 'method and source code helpers' stamp: 'RNG 5/12/2019 23:25:05'!
selectorOfMethodToExtractCodeFrom

	^ #mExtractMethodExample:! !

!ExtractMethodTest methodsFor: 'method and source code helpers' stamp: 'RNG 9/8/2019 18:40:40'!
sourceCodeOfMethodToExtractCodeFrom

	^ self selectorOfMethodToExtractCodeFrom, ' anArgument

	<anAnnoyingPragma>
	| localVar |
	<anotherAnnoyingPragma>
	self m1.
	self m2: ''hey true''.
	self m3: anArgument , ''^ 21''.
	localVar _ Set with: ''hello''.
	localVar := #($x $y $z) size and: [ (9) * 3 ].
	^ localVar + ((4))'! !

!ExtractMethodTest methodsFor: 'method and source code helpers' stamp: 'RNG 6/23/2019 19:47:39'!
updatedSourceCodeAfterExtracting: anInterval 

	^ self updatedSourceCodeAfterExtracting: anInterval to: newUnaryMessage! !

!ExtractMethodTest methodsFor: 'method and source code helpers' stamp: 'RNG 6/23/2019 19:46:56'!
updatedSourceCodeAfterExtracting: anInterval to: newMessage

	^ self sourceCodeOfMethodToExtractCodeFrom
		copyReplaceFrom: anInterval first
		to: anInterval last
		with: 'self ' , newMessage fullName! !

!ExtractMethodTest methodsFor: 'method and source code helpers' stamp: 'RNG 6/23/2019 18:33:05'!
updatedSourceCodeAfterExtractingNewMethod

	^ self updatedSourceCodeAfterExtracting: self intervalToExtractFromMethod ! !

!ExtractMethodTest methodsFor: 'refactoring helpers' stamp: 'RNG 7/7/2019 23:42:34'!
applyExtractMethodOf: anInterval on: aCategory 

	self applyExtractMethodOf: anInterval to: newUnaryMessage on: aCategory! !

!ExtractMethodTest methodsFor: 'refactoring helpers' stamp: 'RNG 7/7/2019 23:42:22'!
applyExtractMethodOf: anInterval to: newMessage on: aCategory

	(ExtractMethod
		fromInterval: anInterval
		of: self methodToExtractCodeFrom
		to: newMessage
		categorizedAs: aCategory) apply! !

!ExtractMethodTest methodsFor: 'refactoring helpers' stamp: 'RNG 6/23/2019 18:34:56'!
applyExtractMethodOn: aCategory

	self applyExtractMethodOf: self intervalToExtractFromMethod on: aCategory! !

!ExtractMethodTest methodsFor: 'refactoring helpers' stamp: 'RNG 9/27/2019 23:24:08'!
intervalOf: aPieceOfSourceCode locatedIn: sourceCode

	| interval |
	interval _ sourceCode intervalOfSubCollection: aPieceOfSourceCode.
	^ interval first to: interval last - 1! !

!ExtractMethodTest methodsFor: 'refactoring helpers' stamp: 'RNG 9/27/2019 23:46:18'!
intervalOfCode: aPieceOfSourceCode

	^ self intervalOf: aPieceOfSourceCode locatedIn: self sourceCodeOfMethodToExtractCodeFrom! !

!ExtractMethodTest methodsFor: 'set up' stamp: 'RNG 6/23/2019 19:24:46'!
setUp

	super setUp.
	classToRefactor _ self createClassNamed: self classToRefactorName.
	self compileMethodToExtractCodeFrom.
	newUnaryMessage _ Message selector: #newMethod.
	newUnarySelector _ newUnaryMessage selector! !

!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 9/27/2019 23:54:13'!
test09ExtractingALiteralCreatesANewMethodAndChangesExistingCodeToCallThatNewMethod

	| codeToExtract newMethodCode originalCode updatedCode |
	codeToExtract _ '4'.
	originalCode _ 'm1 ^ ' , codeToExtract.
	newMethodCode _ 'm2

	^ ' , codeToExtract.
	updatedCode _ 'm1 ^ self m2'.

	self
		extract: codeToExtract from: originalCode withSelector: #m2
		defines: newMethodCode andUpdates: updatedCode! !

!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 6/23/2019 19:24:46'!
test15ExtractingAListOfStatementsCreatesANewMethodWithoutReturn

	| codeToExtract intervalToExtract sourceCodeOfNewMethod originalSelector updatedSourceCodeOfOriginalMethod |
	codeToExtract _
	'self m1.
	self m2: ''hey true'''.
	intervalToExtract _ self intervalOfCode: codeToExtract.
	sourceCodeOfNewMethod _ self newMethodDefinitionWith: codeToExtract.
	originalSelector _ self selectorOfMethodToExtractCodeFrom.
	updatedSourceCodeOfOriginalMethod _ self updatedSourceCodeAfterExtracting: intervalToExtract .

	self applyExtractMethodOf: intervalToExtract on: #category.

	self assertClassHasDefined: newUnarySelector withBody: sourceCodeOfNewMethod inCategory: #category.
	self assertClassHasDefined: originalSelector withBody: updatedSourceCodeOfOriginalMethod! !

!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 9/27/2019 23:52:33'!
test17AStringContainingTheReturnCharacterCanBeExtracted
	"this is to make sure the return is found using AST logic, not by text"

	| codeToExtract newMethodCode originalCode updatedCode |
	codeToExtract _ '''^ 3'' size'.
	originalCode _ 'm1 ^ ' , codeToExtract.
	newMethodCode _ 'm2

	^ ' , codeToExtract.
	updatedCode _ 'm1 ^ self m2'.

	self
		extract: codeToExtract from: originalCode withSelector: #m2
		defines: newMethodCode andUpdates: updatedCode! !

!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 6/23/2019 19:24:46'!
test18ExtractingAListOfStatementsIncludingDotsRemovesThemAndContinuesWithMethodExtraction

	| codeToExtract intervalToExtract actualIntervalToExtract sourceCodeOfNewMethod updatedSourceCodeOfOriginalMethod expectedExtractedCode |
	codeToExtract _
	'
	self m1.
	self m2: ''hey true''.'.
	expectedExtractedCode _ "trimmed initial enter and space, and ending dot"
	'self m1.
	self m2: ''hey true'''.
	intervalToExtract _ self intervalOfCode: codeToExtract.
	actualIntervalToExtract _ self intervalOfCode: expectedExtractedCode.
	updatedSourceCodeOfOriginalMethod _ self updatedSourceCodeAfterExtracting: actualIntervalToExtract .
	sourceCodeOfNewMethod _ self newMethodDefinitionWith: expectedExtractedCode.

	self applyExtractMethodOf: intervalToExtract on: #category.

	self assertClassHasDefined: newUnarySelector withBody: sourceCodeOfNewMethod inCategory: #category.
	self assertClassHasDefined: self selectorOfMethodToExtractCodeFrom withBody: updatedSourceCodeOfOriginalMethod! !

!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 9/27/2019 23:50:31'!
test19ASelectionContainingAdditionalParenthesesAtTheBeginningAndOrEndCanBeExtracted

	| codeToExtract newMethodCode originalCode updatedCode |
	codeToExtract _ '((42))'.
	originalCode _ 'm1 ^ ' , codeToExtract.
	newMethodCode _ 'm2

	^ 42'.
	updatedCode _ 'm1 ^ ((self m2))'.

	self
		extract: codeToExtract from: originalCode withSelector: #m2
		defines: newMethodCode andUpdates: updatedCode! !

!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 6/23/2019 21:15:08'!
test20ASelectionContainingALocalVariableIsParameterizedOnTheExtractedMessage

	| codeToExtract intervalToExtract sourceCodeOfNewMethod originalSelector updatedSourceCodeOfOriginalMethod newMessage |
	codeToExtract _ 'anArgument , ''^ 21'''.
	newMessage _ Message selector: #extractWithParam: arguments: { 'anArgument' }.
	intervalToExtract _ self intervalOfCode: codeToExtract.
	sourceCodeOfNewMethod _ self newMethodDefinitionOf: newMessage including: '^ ' , codeToExtract.
	originalSelector _ self selectorOfMethodToExtractCodeFrom.
	updatedSourceCodeOfOriginalMethod _ self updatedSourceCodeAfterExtracting: intervalToExtract to: newMessage.

	self applyExtractMethodOf: intervalToExtract to: newMessage on: #category.

	self assertClassHasDefined: newMessage selector withBody: sourceCodeOfNewMethod inCategory: #category.
	self assertClassHasDefined: originalSelector withBody: updatedSourceCodeOfOriginalMethod! !

!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 9/27/2019 23:42:52'!
test21ASelectionContainingAdditionalParenthesesOnOneSideCanBeExtractedAndItIsNotTrimmed

	| codeToExtract newMethodCode originalCode updatedCode |
	codeToExtract _ '(9) * 3'.
	originalCode _ 'm1 ^ ' , codeToExtract.
	newMethodCode _ 'm2

	^ ' , codeToExtract.
	updatedCode _ 'm1 ^ self m2'.

	self
		extract: codeToExtract from: originalCode withSelector: #m2
		defines: newMethodCode andUpdates: updatedCode! !

!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 9/7/2019 19:27:09'!
test22ItIsPossibleToExtractTheLastExpressionOfAMethod

	| codeToExtract intervalToExtract sourceCodeOfNewMethod originalSelector updatedSourceCodeOfOriginalMethod |
	codeToExtract _ 'localVar + ((4))'.
	intervalToExtract _ self intervalOfCode: codeToExtract.
	sourceCodeOfNewMethod _ self newMethodDefinitionWith: '^ ', codeToExtract.
	originalSelector _ self selectorOfMethodToExtractCodeFrom.
	updatedSourceCodeOfOriginalMethod _ self updatedSourceCodeAfterExtracting: intervalToExtract.

	self applyExtractMethodOf: intervalToExtract on: #category.

	self assertClassHasDefined: newUnarySelector withBody: sourceCodeOfNewMethod inCategory: #category.
	self assertClassHasDefined: originalSelector withBody: updatedSourceCodeOfOriginalMethod! !

!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 9/27/2019 23:39:47'!
test26ItIsPossibleToExtractAnEntireBlockIncludingALocalAssignment

	| codeToExtract newMethodCode originalCode updatedCode |
	codeToExtract _ '[ |something| something _ 3 ]'.
	originalCode _ 'm1 ^ ' , codeToExtract.
	newMethodCode _ 'm2

	^ ' , codeToExtract.
	updatedCode _ 'm1 ^ self m2'.

	self
		extract: codeToExtract from: originalCode withSelector: #m2
		defines: newMethodCode andUpdates: updatedCode! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/22/2019 22:29:34'!
test01NewSelectorShouldNotBeEmpty

	self
		tryingToExtractWithSelectorNamed: #''
		failsWith: ExtractMethodNewSelectorPrecondition newSelectorCanNotBeEmptyErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/22/2019 22:29:34'!
test02NewSelectorShouldNotContainSeparators

	self
		tryingToExtractWithSelectorNamed: #'my selector'
		failsWith: ExtractMethodNewSelectorPrecondition newSelectorCanNotContainSeparatorsErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/22/2019 22:29:34'!
test03NewSelectorShouldNotBeAlreadyDefinedInTheClass

	self
		tryingToExtractWithSelectorNamed: self selectorOfMethodToExtractCodeFrom
		failsWith: ExtractMethodNewSelectorPrecondition newSelectorAlreadyDefinedOnTheClassErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/22/2019 22:29:34'!
test04NewSelectorShouldNotStartWithANumber

	self
		tryingToExtractWithSelectorNamed: #'2selector'
		failsWith: ExtractMethodNewSelectorPrecondition invalidStartingCharacterOfNewSelectorErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/22/2019 22:29:34'!
test05NewUnarySelectorShouldNotStartWithASymbol

	self
		tryingToExtractWithSelectorNamed: #-
		failsWith: ExtractMethodNewSelectorPrecondition invalidStartingCharacterOfNewSelectorErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/22/2019 22:30:00'!
test06IntervalToExtractIsNotBeforeMethodSourceCodeBoundaries

	self
		tryingToExtractOnInterval: (-1 to: 2)
		failsWith: ExtractMethod outOfBoundsSelectionErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/22/2019 22:30:00'!
test07IntervalToExtractIsNotAfterMethodSourceCodeBoundaries

	self
		tryingToExtractOnInterval: (1 to: self sourceCodeOfMethodToExtractCodeFrom size + 2)
		failsWith: ExtractMethod outOfBoundsSelectionErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/22/2019 22:30:00'!
test08IntervalToExtractShouldNotContainAReturnExpression

	self
		tryingToExtractOnInterval: (self intervalOfCode: '^ localVar + ((4))')
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/22/2019 22:30:00'!
test10IntervalToExtractDoesNotContainsPartOfTheOriginalSelector

	| intervalToExtract |
	intervalToExtract  _ self intervalOfCode: self selectorOfMethodToExtractCodeFrom asString.
	self
		tryingToExtractOnInterval: intervalToExtract
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/22/2019 22:30:00'!
test11IntervalToExtractDoesNotContainsPartOfLocalVariablesDefinition

	self
		tryingToExtractOnInterval: (self intervalOfCode: '| localVar |')
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/22/2019 22:30:00'!
test12IntervalToExtractDoesNotContainsPartOfPragmasDefinition

	self
		tryingToExtractOnInterval: (self intervalOfCode: '<anotherAnnoyingPragma>')
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/22/2019 22:30:00'!
test13IntervalToExtractShouldBeAValidSmalltalkExpression

	self
		tryingToExtractOnInterval: (self intervalOfCode: '+ ((4))')
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/22/2019 22:30:00'!
test14ItIsNotPossibleToExtractTheLeftSideOfAnAssignment

	| firstOccurrence secondOccurrence intervalToExtract |
	firstOccurrence _ self sourceCodeOfMethodToExtractCodeFrom
		indexOfSubCollection: 'localVar' startingAt: 1.
	secondOccurrence _ self sourceCodeOfMethodToExtractCodeFrom
		indexOfSubCollection: 'localVar' startingAt: firstOccurrence + 1.
	intervalToExtract _ secondOccurrence toSelfPlus: 'localVar' size.
	self
		tryingToExtractOnInterval: intervalToExtract
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/22/2019 22:30:00'!
test16CanNotExtractPartOfALiteral

	self
		tryingToExtractOnInterval: (self intervalOfCode: 'true')
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/22/2019 22:30:00'!
test23CanNotExtractWithAnInvalidInterval

	self
		tryingToExtractOnInterval: (10 to: 9)
		failsWith: ExtractMethod noSelectionErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/22/2019 22:30:00'!
test24ItIsNotPossibleToExtractAnIntervalIncludingATemporaryAssignmentExpression

	self
		tryingToExtractOnInterval: (self intervalOfCode: 'localVar _ Set with: ''hello''')
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/22/2019 22:29:34'!
test25NewUnarySelectorShouldNotContainInvalidCharacters

	self
		tryingToExtractWithSelectorNamed: 'hola)' asSymbol
		failsWith: ExtractMethodNewSelectorPrecondition invalidCharacterInsideNewSelectorErrorMessage! !
