<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Blockchain Attendance System</title>

    <link rel="stylesheet" href="main.css">

    <!-- Web3 -->
    <script src="https://cdn.jsdelivr.net/gh/ethereum/web3.js@0.18.2/dist/web3.min.js"></script>

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
</head>

<body>

    <div class="container">

        <h1>Attendance Management using Blockchain</h1>

        <!-- Student Registration -->
        <fieldset>
            <legend>Student Registration</legend>

            <h2 id="studentdetails"></h2>

            <label>Student ID</label>
            <input id="id" type="text" placeholder="Enter Student ID">

            <label>Age</label>
            <input id="age" type="text" placeholder="Enter Age">

            <label>First Name</label>
            <input id="fname" type="text" placeholder="Enter First Name">

            <label>Last Name</label>
            <input id="lname" type="text" placeholder="Enter Last Name">

            <button id="button">Register Student</button>
        </fieldset>

        <!-- Increment Attendance -->
        <fieldset>
            <legend>Increment Attendance</legend>

            <h2 id="attendance"></h2>

            <label>Student ID</label>
            <input id="idAttendance" type="text"
                placeholder="Enter Student ID">

            <button id="btnIncAttnd">Increment Attendance</button>
        </fieldset>

        <!-- Get Student Details -->
        <fieldset>
            <legend>Get Student Details</legend>

            <h2 id="stdDetails"></h2>

            <label>Student ID</label>
            <input id="idDetails" type="text"
                placeholder="Enter Student ID">

            <button id="btnDetails">Get Details</button>
        </fieldset>

        <!-- Get All Students -->
        <fieldset>
            <legend>Get All Student Details</legend>

            <h2 id="stdAllDetails"></h2>

            <button id="btnAllDetails">Get All Details</button>
        </fieldset>

        <!-- Student Count -->
        <fieldset>
            <legend>Students Count</legend>

            <h2 id="stdCount"></h2>

            <button id="btnCount">Get Students Count</button>
        </fieldset>

        <!-- Student ID List -->
        <fieldset>
            <legend>Students ID List</legend>

            <h2 id="stdIds"></h2>

            <button id="btnStdIds">Get Student IDs</button>
        </fieldset>

    </div>

    <script>

        // Web3 Initialization

        if (typeof web3 !== 'undefined') {
            web3 = new Web3(web3.currentProvider);
        } else {

            web3 = new Web3(
                new Web3.providers.HttpProvider("http://localhost:8545")
            );
        }

        // Default Account

        web3.eth.defaultAccount = web3.eth.accounts[0];

        // Smart Contract ABI

        var attendanceContract = web3.eth.contract([

            {
                "constant": true,
                "inputs": [],
                "name": "countStudents",
                "outputs": [
                    {
                        "name": "",
                        "type": "uint256"
                    }
                ],
                "type": "function"
            },

            {
                "constant": true,
                "inputs": [
                    {
                        "name": "_studId",
                        "type": "uint256"
                    }
                ],
                "name": "getParticularStudent",
                "outputs": [
                    {
                        "name": "",
                        "type": "string"
                    },
                    {
                        "name": "",
                        "type": "string"
                    },
                    {
                        "name": "",
                        "type": "uint256"
                    },
                    {
                        "name": "",
                        "type": "uint256"
                    }
                ],
                "type": "function"
            },

            {
                "constant": false,
                "inputs": [
                    {
                        "name": "_studId",
                        "type": "uint256"
                    },
                    {
                        "name": "_age",
                        "type": "uint256"
                    },
                    {
                        "name": "_fName",
                        "type": "string"
                    },
                    {
                        "name": "_lName",
                        "type": "string"
                    }
                ],
                "name": "createStudent",
                "outputs": [],
                "type": "function"
            },

            {
                "constant": true,
                "inputs": [],
                "name": "getStudents",
                "outputs": [
                    {
                        "name": "",
                        "type": "uint256[]"
                    }
                ],
                "type": "function"
            },

            {
                "constant": false,
                "inputs": [
                    {
                        "name": "_studId",
                        "type": "uint256"
                    }
                ],
                "name": "incrementAttendance",
                "outputs": [],
                "type": "function"
            }

        ]);

        // Contract Address

        var AttendanceManagement =
            attendanceContract.at(
                '0xA090399e38C512F0249796Ea937Ed529f77f1c9E'
            );

        console.log(AttendanceManagement);

        // Register Student

        $("#button").click(function () {

            AttendanceManagement.createStudent(
                $("#id").val(),
                $("#age").val(),
                $("#fname").val(),
                $("#lname").val()
            );

            alert("Student Registered Successfully");
        });

        // Increment Attendance

        $("#btnIncAttnd").click(function () {

            AttendanceManagement.incrementAttendance(
                $("#idAttendance").val()
            );

            AttendanceManagement.getParticularStudent(
                $("#idAttendance").val(),

                function (error, result) {

                    if (!error) {

                        $("#attendance").html(
                            'Attendance Incremented to ' +
                            result[3] +
                            ' for ' +
                            result[0] +
                            ' ' +
                            result[1]
                        );

                    } else {
                        console.error(error);
                    }
                }
            );
        });

        // Get Particular Student Details

        $("#btnDetails").click(function () {

            AttendanceManagement.getParticularStudent(
                $("#idDetails").val(),

                function (error, result) {

                    if (!error) {

                        $("#stdDetails").html(
                            'Name: ' + result[0] + ' ' + result[1] +
                            '<br>' +
                            'Age: ' + result[2] +
                            '<br>' +
                            'Attendance: ' + result[3] + ' Days Present'
                        );

                    } else {
                        console.error(error);
                    }
                }
            );
        });

        // Get Students Count

        $("#btnCount").click(function () {

            AttendanceManagement.countStudents(
                function (error, result) {

                    if (!error) {

                        $("#stdCount").html(
                            'There are currently ' +
                            result +
                            ' students'
                        );

                    } else {
                        console.error(error);
                    }
                }
            );
        });

        // Get Student IDs

        $("#btnStdIds").click(function () {

            $("#stdIds").html("");

            AttendanceManagement.getStudents(
                function (error, result) {

                    if (!error) {

                        $.each(result, function (index, value) {

                            $("#stdIds").append(
                                "Student " +
                                (index + 1) +
                                ": " +
                                value +
                                "<br>"
                            );
                        });

                    } else {
                        console.error(error);
                    }
                }
            );
        });

        // Get All Student Details

        $("#btnAllDetails").click(function () {

            $("#stdAllDetails").html("");

            AttendanceManagement.getStudents(
                function (error, result) {

                    if (!error) {

                        $.each(result, function (index, value) {

                            AttendanceManagement.getParticularStudent(
                                value,

                                function (error, result) {

                                    if (!error) {

                                        $("#stdAllDetails").append(

                                            'Name: ' +
                                            result[0] +
                                            ' ' +
                                            result[1] +
                                            '<br>' +

                                            'Age: ' +
                                            result[2] +
                                            '<br>' +

                                            'Attendance: ' +
                                            result[3] +
                                            ' Days Present' +

                                            '<br><br>'
                                        );

                                    } else {
                                        console.error(error);
                                    }
                                }
                            );
                        });

                    } else {
                        console.error(error);
                    }
                }
            );
        });

    </script>

</body>
</html>
