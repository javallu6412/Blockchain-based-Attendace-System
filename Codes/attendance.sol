// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
contract AttendanceSheet {
    address public owner;
    constructor() {
        owner = msg.sender;
    }
    struct Student {
        uint age;
        string fName;
        string lName;
        uint attendanceValue;
    }
    mapping(uint => Student) public studentList;
    uint[] public studIdList;
    event StudentCreated(
        uint studId,
        string fName,
        string lName,
        uint age
    );
    function createStudent(
        uint _studId,
        uint _age,
        string memory _fName,
        string memory _lName
    ) public {
        Student storage student = studentList[_studId];
        student.age = _age;
        student.fName = _fName;
        student.lName = _lName;
        student.attendanceValue = 0;
        studIdList.push(_studId);
        emit StudentCreated(_studId, _fName, _lName, _age);
    }
    function incrementAttendance(uint _studId) public {
        studentList[_studId].attendanceValue++;
    }
    function getStudents() public view returns(uint[] memory) {
        return studIdList;
    }
    function getParticularStudent(uint _studId)
        public view
        returns(string memory, string memory, uint, uint)
    {
        Student memory student = studentList[_studId];
        return (student.fName, student.lName, student.age, student.attendanceValue);
    }
    function countStudents() public view returns(uint) {
        return studIdList.length;
    }
}
