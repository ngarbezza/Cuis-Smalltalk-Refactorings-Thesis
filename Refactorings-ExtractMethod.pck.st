'From Cuis 5.0 of 7 November 2016 [latest update: #3741] on 23 May 2019 at 1:30:22 am'!
'Description Extract Method refactoring.'!
!provides: 'Refactorings-ExtractMethod' 1 3!
SystemOrganization addCategory: #'Refactorings-ExtractMethod'!


!classDefinition: #ExtractMethod category: #'Refactorings-ExtractMethod'!
Refactoring subclass: #ExtractMethod
	instanceVariableNames: 'intervalToExtract sourceMethod newSelector categoryOfNewSelector'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Refactorings-ExtractMethod'!
!classDefinition: 'ExtractMethod class' category: #'Refactorings-ExtractMethod'!
ExtractMethod class
	instanceVariableNames: ''!

!classDefinition: #ExtractMethodApplier category: #'Refactorings-ExtractMethod'!
RefactoringApplier subclass: #ExtractMethodApplier
	instanceVariableNames: 'intervalToExtract methodToExtractCodeFrom newSelector'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Refactorings-ExtractMethod'!
!classDefinition: 'ExtractMethodApplier class' category: #'Refactorings-ExtractMethod'!
ExtractMethodApplier class
	instanceVariableNames: ''!

!classDefinition: #ExtractMethodNewSelectorPrecondition category: #'Refactorings-ExtractMethod'!
RefactoringPrecondition subclass: #ExtractMethodNewSelectorPrecondition
	instanceVariableNames: 'selectorToValidate classToDefineSelector'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Refactorings-ExtractMethod'!
!classDefinition: 'ExtractMethodNewSelectorPrecondition class' category: #'Refactorings-ExtractMethod'!
ExtractMethodNewSelectorPrecondition class
	instanceVariableNames: ''!

!classDefinition: #ExtractMethodEditorMenu category: #'Refactorings-ExtractMethod'!
Object subclass: #ExtractMethodEditorMenu
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Refactorings-ExtractMethod'!
!classDefinition: 'ExtractMethodEditorMenu class' category: #'Refactorings-ExtractMethod'!
ExtractMethodEditorMenu class
	instanceVariableNames: ''!


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

!ExtractMethod methodsFor: 'source code' stamp: 'RNG 5/13/2019 03:13:20'!
newMethodSourceCode

	| extractedSource parseNode return |
	extractedSource _ sourceMethod sourceCode copyFrom: intervalToExtract first to: intervalToExtract last - 1.
	parseNode _ Parser parse: extractedSource class: sourceMethod methodClass noPattern: true.
	return _ parseNode block statements size = 1 ifTrue: [ '^ ' ] ifFalse: [ '' ].
	^ newSelector asString , String lfString , String lfString , String tab , return , extractedSource! !

!ExtractMethod methodsFor: 'source code' stamp: 'RNG 5/7/2019 00:12:04'!
updatedSourceCodeOfExistingMethod

	^ sourceMethod sourceCode
		copyReplaceFrom: intervalToExtract first
		to: intervalToExtract last - 1
		with: 'self ', newSelector asString! !

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

!ExtractMethod class methodsFor: 'validations' stamp: 'RNG 5/13/2019 02:42:36'!
ensure: anIntervalToExtract isValidIntervalOn: aMethodToExtractCodeFrom 

	(self is: anIntervalToExtract withinBoundsOf: aMethodToExtractCodeFrom sourceCode)
		ifFalse: [ self signalOutOfBoundsIntervalError ].
	(self is: anIntervalToExtract partOfMethodDefinitionOf: aMethodToExtractCodeFrom)
		ifTrue: [ self signalSelectedCodeIsInvalidForExtractError ].
	(self method: aMethodToExtractCodeFrom containsAValidExpressionOn: anIntervalToExtract)
		ifFalse: [ self signalSelectedCodeIsInvalidForExtractError ].
	(self doesNotCauseSyntaxError: anIntervalToExtract whenExtractedOn: aMethodToExtractCodeFrom)
		ifFalse: [ self signalSelectedCodeIsInvalidForExtractError ].
	(self containsAReturnExpression: aMethodToExtractCodeFrom sourceCode onInterval: anIntervalToExtract)
		ifTrue: [ self signalReturnInSourceToExtractError ]! !

!ExtractMethod class methodsFor: 'error messages' stamp: 'RNG 4/20/2019 21:53:45'!
outOfBoundsSelectionErrorMessage

	^ 'The source code selection interval is out of bounds'! !

!ExtractMethod class methodsFor: 'error messages' stamp: 'RNG 4/28/2019 23:49:05'!
returnInSourceToExtractErrorMessage

	^ 'Can not extract this piece of code: there is a return expression'! !

!ExtractMethod class methodsFor: 'error messages' stamp: 'RNG 5/12/2019 23:42:45'!
selectedCodeInvalidForExtractErrorMessage

	^ 'The selected code can not be extracted to a method'! !

!ExtractMethod class methodsFor: 'exceptions' stamp: 'RNG 4/20/2019 21:53:24'!
signalOutOfBoundsIntervalError

	self refactoringError: self outOfBoundsSelectionErrorMessage! !

!ExtractMethod class methodsFor: 'exceptions' stamp: 'RNG 4/28/2019 23:55:45'!
signalReturnInSourceToExtractError

	self refactoringError: self returnInSourceToExtractErrorMessage! !

!ExtractMethod class methodsFor: 'exceptions' stamp: 'RNG 5/12/2019 23:54:19'!
signalSelectedCodeIsInvalidForExtractError

	self refactoringError: self selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethod class methodsFor: 'parsing - private' stamp: 'RNG 5/13/2019 02:40:15'!
canBeParsed: selectedCode on: aClass asMethod: isFullMethod

	[ Parser parse: selectedCode class: aClass noPattern: isFullMethod not ]
		on: SyntaxErrorNotification do: [ ^ false ].
	^ true! !

!ExtractMethod class methodsFor: 'validations - private' stamp: 'RNG 4/29/2019 00:25:20'!
containsAReturnExpression: aSourceCode onInterval: anIntervalToExtract 

	^ (aSourceCode copyFrom: anIntervalToExtract first to: anIntervalToExtract last - 1) includes: $^! !

!ExtractMethod class methodsFor: 'validations - private' stamp: 'RNG 5/13/2019 02:42:17'!
doesNotCauseSyntaxError: anIntervalToExtract whenExtractedOn: aMethodToExtractCodeFrom

	| newSourceCode |
	newSourceCode _ aMethodToExtractCodeFrom sourceCode
		copyReplaceFrom: anIntervalToExtract first
		to: anIntervalToExtract last - 1
		with: 'self xxxxx'.
	^ self
		canBeParsed: newSourceCode
		on: aMethodToExtractCodeFrom methodClass
		asMethod: true! !

!ExtractMethod class methodsFor: 'validations - private' stamp: 'RNG 5/13/2019 03:07:07'!
is: anIntervalToExtract partOfMethodDefinitionOf: aMethodToExtractCodeFrom

	| actualMethodBeginning |
	actualMethodBeginning _ Parser new
		indexOfFirstStatementOf: aMethodToExtractCodeFrom sourceCode.

	^ anIntervalToExtract first < actualMethodBeginning! !

!ExtractMethod class methodsFor: 'validations - private' stamp: 'RNG 4/28/2019 23:52:09'!
is: anIntervalToExtract withinBoundsOf: aSourceCode

	^ anIntervalToExtract first >= 1 and: [ anIntervalToExtract last - 1 <= aSourceCode size ]! !

!ExtractMethod class methodsFor: 'validations - private' stamp: 'RNG 5/23/2019 01:02:19'!
method: aMethod containsAValidExpressionOn: anIntervalToExtract

	| source selectedCode last canBeParsed parseNodeOne parseNodeTwo actualInterval |
	source _ aMethod sourceCode.
	last  _ anIntervalToExtract last - 1.
	selectedCode _ source copyFrom: anIntervalToExtract first to: last.

	canBeParsed _ self canBeParsed: selectedCode on: aMethod methodClass asMethod: false.
	parseNodeOne  _ aMethod methodNode parseNodeIncluding: anIntervalToExtract first ifAbsent: [ ^ false].
	actualInterval _ parseNodeOne value.
	[ (source at: actualInterval first) isSeparator ] whileTrue: [ actualInterval _ actualInterval first + 1 to: actualInterval last ].
	parseNodeTwo  _ aMethod methodNode parseNodeIncluding: last ifAbsent: [ ^ false].
	actualInterval _ actualInterval first to: parseNodeTwo value last.
	^ canBeParsed & (actualInterval = (anIntervalToExtract first to: last))! !

!ExtractMethodApplier methodsFor: 'refactoring - creation' stamp: 'RNG 5/13/2019 02:17:03'!
createRefactoring

	^ ExtractMethod
		fromInterval: intervalToExtract
		of: methodToExtractCodeFrom
		to: newSelector
		categorizedAs: methodToExtractCodeFrom category! !

!ExtractMethodApplier methodsFor: 'refactoring - parameters request' stamp: 'RNG 5/13/2019 02:21:23'!
askNewSelector

	newSelector _ (self request: 'New method name:') asSymbol! !

!ExtractMethodApplier methodsFor: 'refactoring - parameters request' stamp: 'RNG 5/13/2019 02:20:11'!
requestRefactoringParameters

	self askNewSelector! !

!ExtractMethodApplier methodsFor: 'refactoring - changes' stamp: 'RNG 5/13/2019 02:17:27'!
showChanges! !

!ExtractMethodApplier methodsFor: 'initialization' stamp: 'RNG 5/13/2019 02:32:19'!
initializeFor: anIntervalToExtract of: aMethodToExtractCodeFrom

	intervalToExtract _ anIntervalToExtract.
	methodToExtractCodeFrom _ aMethodToExtractCodeFrom! !

!ExtractMethodApplier class methodsFor: 'pre-conditions' stamp: 'RNG 5/13/2019 02:06:39'!
assertCanApplyRefactoringOn: aMethodToExtractCodeFrom at: anIntervalToExtract

	ExtractMethod
		ensure: anIntervalToExtract
		isValidIntervalOn: aMethodToExtractCodeFrom! !

!ExtractMethodApplier class methodsFor: 'instance creation' stamp: 'RNG 5/13/2019 02:32:10'!
for: anIntervalToExtract of: aMethodToExtractCodeFrom

	| intervalToExtract |
	intervalToExtract _ anIntervalToExtract first to: anIntervalToExtract last + 1.
	self assertCanApplyRefactoringOn: aMethodToExtractCodeFrom at: intervalToExtract.

	^ self new initializeFor: intervalToExtract of: aMethodToExtractCodeFrom! !

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

!ExtractMethodEditorMenu class methodsFor: 'shortcuts' stamp: 'RNG 5/13/2019 01:25:03'!
smalltalkEditorCmdShortcutsSpec

	^#(#($M #extractMethod: 'Extracts the selected code into a separate method'))! !

!ExtractMethodEditorMenu class methodsFor: 'menu items' stamp: 'RNG 5/13/2019 01:21:46'!
smalltalkEditorMenuOptions

	^`{
		{
				#itemGroup 		-> 		35.
				#itemOrder 		-> 		20.
				#label 			-> 		'Extract Method... (M)'.
				#selector 		-> 		#extractMethod.
				#icon 			-> 		#saveAsIcon
		} asDictionary
	}`! !

!Parser methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 5/13/2019 01:05:13'!
bindTemp: aString range: anInterval 
! !

!Parser methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 5/13/2019 01:11:09'!
indexOfFirstStatementOf: aSourceCode
	"Scans until it finds the first statement of the method represented by aSourceCode"

	self parseSelector: aSourceCode; pragmaSequence.
	encoder _ self.
	self temporaries; pragmaSequence.
	^ hereMark! !

!SmalltalkEditor methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 5/17/2019 08:20:04'!
extractMethod

	morph owningWindow okToChange ifTrue: [
		ExtractMethodApplier createAndValueHandlingExceptions: [
			ExtractMethodApplier for: self selectionInterval of: self codeProvider currentCompiledMethod ] ]! !

!SmalltalkEditor methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 5/9/2019 00:06:54'!
extractMethod: aKeyboardEvent

	self extractMethod.
	^true! !
