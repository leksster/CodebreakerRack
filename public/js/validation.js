function validate() {
  var input = document.forms["main"]["guess"].value;

  if ( input == null || input == "") {
    alert("Field is empty");
    return false;

  } else if (/[^1-6]/.test(input)) {
    alert("Only numbers within 1..6 range allowed");
    return false;
    
  } else if (input.length != 4) {
    alert("4 digits required");
    return false;
  };

}