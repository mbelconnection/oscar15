function validateSearchForm() {
	if (document.forms[0].elements['firstName'].value == '' || document.forms[0].elements['lastName'].value == '') {
		alert('First name and last name are mandatory');
		
		return false;
	}
			
	return true;
}

function validateEdit() {
	var firstName = getElement('client.firstName');
	var lastName = getElement('client.lastName');
	
	if (isEmpty(firstName.value)) {
		return error(firstName, "First name is mandatory");
	} else if (isEmpty(lastName.value)) {
		return error(lastName, "Last name is mandatory");
	}

	var month = getElement('client.monthOfBirth');
	var day = getElement('client.dateOfBirth');
	var year = getElement('client.yearOfBirth');

	if (!isEmpty(month.value) || !isEmpty(day.value) || !isEmpty(year.value)) {
		var date = month.value + "/" + day.value + "/" + year.value;
		
		if (!dojo.validate.isValidDate(date, 'MM/DD/YYYY')) {
			return error(month, date + " (MM/DD/YYYY) is not a valid date");
		}
	}
	
	var email = getElement('client.email');
	
	if (!isEmpty(email.value) && !dojo.validate.isEmailAddress(email.value)) {
		return error(email, email.value + " is not a valid email address");
	}
	
	var phoneNumber = getElement('client.phone');

	if (!isEmpty(phoneNumber.value) && !dojo.validate.us.isPhoneNumber(phoneNumber.value)) {
		return error(phoneNumber, phoneNumber.value + " is not a valid phone number");
	}

	var secondaryPhoneNumber = getElement('client.phone2');

	if (!isEmpty(secondaryPhoneNumber.value) && !dojo.validate.us.isPhoneNumber(secondaryPhoneNumber.value)) {
		return error(secondaryPhoneNumber, secondaryPhoneNumber.value + " is not a valid phone number");
	}
		
	if (!hasSelection(getElement('serviceProgramIds'))) {
		return window.confirm("No service program has been selected.\nAre you sure you want to submit?");
	}
	
	return true;
}

function search() {
	setMethod('search');
}

function createLocal() {
	if (confirm("A client with a similar first and last name was found. Are you sure this isn't the client you are looking for?")) {
		setMethod('createLocal');
		
		return true;
	} else {
		return false;
	}
}

function updateLocal(clientId) {
	document.forms[0].elements['clientId'].value = clientId;
	setMethod('updateLocal');
}

function copyRemote(agencyId, clientId) {
	document.forms[0].elements['agencyId'].value = agencyId;
	document.forms[0].elements['clientId'].value = clientId;
	setMethod('copyRemote');
}

function save() {
	setMethod('save');
}

function clientEdit() {
	setMethod('clientEdit');
}

function setMethod(target) {
	document.forms[0].method.value=target;
}

function hasSelection(checkBoxGroup) {
	if (checkBoxGroup == null) {
		return true;
	}
	
	if (isArray(checkBoxGroup)) {
		for (i = 0; i < checkBoxGroup.length; i++) {
			if (checkBoxGroup[i].checked) {
				return true;
			}
		}
	} else {
		return checkBoxGroup.checked;
	}
	
	return false;
}

function isArray(obj) {
	return (typeof (obj.length) == "undefined") ? false : true;
}

function isEmpty(elementValue) {
	return elementValue == '';
}

function getElement(name) {
	return document.forms[0].elements[name];
}

function error(element, msg) {
	element.focus();
	alert(msg);
	
	return false;
}