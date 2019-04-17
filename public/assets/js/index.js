$(document).ready(function() {
		//Succes message for forms
		var x = document.getElementById("success");
		x.style.display = "none";
		var y = document.getElementById("contact_success");
		y.style.display = "none"

		$("#contactusform").submit(function() {
			var name = $("#contact_name").val();
			var email = $("#contact_email").val();
			var message = $("#contact_message").val();
			if (name.length < 3) {
				alert("Enter Name");
			} else if (email.length < 3) {
				alert("Enter Email");
			} else if (message.length < 3) {
				alert("Enter Message");
			} else {
				$.ajax({
					url: 'https://script.google.com/macros/s/AKfycbw7WkJCnwNOOfqYB6CdYacwxBl6QmI0z4iA0P8CbC8Ek0kOeh88/exec',
					method: "POST",
					data: {
						"name": name,
						"email": email,
						"message": message
					},
					success: function(response) {
						if (response.result == "success") {

						} else {
							alert("Failed to register! Please try again!");
						}
					},
					error: function(response) {
						alert("Error Occured! Please try again!");
					}
				});
			}
			return false;
		});
		$("#contactform").submit(function() {
			var name = $("#cf_name").val();
			var email = $("#cf_email").val();
			var message = $("#cf_message").val();
			var role = document.getElementById("cf_role").value;
			if (name.length < 3) {
				alert("Enter Name");
			} else if (email.length < 3) {
				alert("Enter Email");
			} else if (message.length < 3) {
				alert("Enter Message");
			} else {
				$.ajax({
					url: 'https://script.google.com/macros/s/AKfycbycPXTgHtTR7wU_3DjPMfLyzsrB54IFUEK5K3noFw/exec',
					method: "POST",
					data: {
						"name": name,
						"email": email,
						"message": message,
						"role": role
					},
					success: function(response) {
						if (response.result == "success") {
							x.style.display = "block";
						} else {
							alert("Failed to send message! Please try again!");
						}
					},
					error: function(response) {
						alert("Error Occured! Please try again!");
					}
				});
			}
			return false;
		});
		$("#maillist").submit(function() {
			var email = $("#maillist_email").val();
			if (email.length < 3) {
				alert("Enter Email");
			} else {
				$.ajax({
					url: 'https://script.google.com/macros/s/AKfycbwNP79_dkUCiPcHUFoVslR9VcTiCkaYCjc4-vm5/exec',
					method: "POST",
					data: {
						"email": email
					},
					success: function(response) {
						if (response.result == "success") {} else {
							alert("Failed to send message! Please try again!");
						}
					},
					error: function(response) {
						alert("Error Occured! Please try again!");
					}
				});
			}
			return false;
		});
	});