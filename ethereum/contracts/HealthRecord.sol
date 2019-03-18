pragma solidity ^0.4.17;

contract HealthRecordFactory{
    address[] public deployedHealthRecords;
    mapping(address => bool) hasDeployedRecord;
    
    struct Provider{
        bytes32 name;
        bytes32 location;
        address provider;
        mapping(address => bool) patients;
    }
    
    Provider[] public providers;
    mapping(address => bool) providers_map;
    
    
    function createHealthRecord(bytes32 name) public {
        require(!hasDeployedRecord[msg.sender]);

        address newHealthRecord = new HealthRecord(name, msg.sender, address(this));
        deployedHealthRecords.push(newHealthRecord);
        
        hasDeployedRecord[msg.sender] = true;
    }

    function getDeployedRecords() public view returns(address[]) {
        return deployedHealthRecords;
    }
    
    function HealthProvider(bytes32 name, bytes32 location) public {
        Provider memory newProvider = Provider({
            name: name,
            location: location,
            provider: msg.sender
        });
        
        providers.push(newProvider);
        providers_map[msg.sender] = true;
        delete(newProvider);
    }

    function getProviderLength() public constant returns(uint) {
        return providers.length;
    }    
    
    function addPatientToProvider(uint index, address _patient) public {
        Provider storage provider = providers[index];
        provider.patients[_patient] = true;
    }
    
    function getPatientOfProvider(uint index, address _patient) public view returns(bool) {
        Provider storage provider = providers[index];
        return provider.patients[_patient];
    }
    
}




contract HealthRecord{
    bytes32 public username;
    address public owner;
    address public factory;
    
    struct Condition{
        bytes32 name;
        bytes32 status;
        bytes32 start_date;
        bytes32 end_date;
        bytes32 how_it_ended;
        address provider;
        mapping(address => bool) approved;
    }
    
    struct Medication{
        bytes32 name;
        bytes32 strength;
        bytes32 dosage;
        uint how_often;
        bytes32 reason;
        bytes32 start_date;
        bytes32 end_date;
        address provider;
        mapping(address => bool) approved;
    }
    
    struct Appointment{
        address provider;
        bytes32 date;
        bytes32 purpose;
        mapping(address => bool) approved;
    }
    
    
    Condition[] public conditions;
    Medication[] public medications;
    Appointment[] public appointments;
    
    
    function HealthRecord(bytes32 _username, address creator, address _factory) public{
        username = _username;
        owner = creator;
        factory = _factory;
    }
    
    modifier restricted() {
        require(msg.sender == owner);
        _;
    }
    
    function addPatientToProviderFactory(uint index) restricted public {
        HealthRecordFactory newFactory = HealthRecordFactory(factory);
        newFactory.addPatientToProvider(index, owner);
    }
    
    function createCondition
        (   
            bytes32 name,
            bytes32 status,
            bytes32 start_date,
            bytes32 end_date,
            bytes32 how_it_ended,
            address provider
        )
    public restricted {
        Condition memory newCondition = Condition({
            name: name,
            status: status,
            start_date: start_date,
            end_date: end_date,
            how_it_ended: how_it_ended,
            provider: provider
        });
        
        conditions.push(newCondition);
    }
    
    function createMedication
        (   
            bytes32 name,
            bytes32 strength,
            bytes32 dosage,
            uint how_often,
            bytes32 reason,
            bytes32 start_date,
            bytes32 end_date,
            address provider
        )
    public restricted {
        Medication memory newMedication = Medication({
            name: name,
            strength: strength,
            dosage: dosage,
            how_often: how_often,
            reason: reason,
            start_date: start_date,
            end_date: end_date,
            provider: provider
        });
        
        medications.push(newMedication);
    }
    
    function createAppointment
        (   
            address provider,
            bytes32 date,
            bytes32 purpose
        )
    public restricted {
        Appointment memory newAppointment = Appointment({
            provider: provider,
            date: date,
            purpose: purpose
        });
        
        appointments.push(newAppointment);
    }
    
    
    function getConditionsLength() public constant restricted returns(uint) {
        return conditions.length;
    }

    function getConditions(uint index) public constant restricted returns(bytes32,bytes32,bytes32,bytes32,bytes32,address,bool) {
        address _provider = conditions[index].provider;
        return (conditions[index].name, conditions[index].status, conditions[index].start_date, conditions[index].end_date,
            conditions[index].how_it_ended, conditions[index].provider,conditions[index].approved[_provider]);
    }
    
    
    function getMedicationsLength() public constant restricted returns(uint) {
        return medications.length;
    }

    function getMedications(uint index) public constant restricted returns(bytes32,bytes32,bytes32,bytes32,bytes32,address,bool) {
        address _provider = medications[index].provider;
        return (medications[index].name,medications[index].strength,medications[index].reason,medications[index].start_date, medications[index].end_date,medications[index].provider,medications[index].approved[_provider]);
    }
    
    function getAppointmentLength() public constant restricted returns(uint) {
        return appointments.length;
    }

    function getAppointment(uint index) public constant restricted returns(address,bytes32,bytes32,bool) {
        address _provider = appointments[index].provider;
        return (appointments[index].provider,appointments[index].date,appointments[index].purpose,appointments[index].approved[_provider]);
    }
    
    function approveCondition(uint index) public {
        address _provider = conditions[index].provider;
        require(msg.sender == _provider);
        
        conditions[index].approved[_provider] = true;
    }
    
    function approveAppointment(uint index) public {
        address _provider = appointments[index].provider;
        require(msg.sender == _provider);
        
        appointments[index].approved[_provider] = true;
    }
    
    function approveMedication(uint index) public {
        address _provider = medications[index].provider;
        require(msg.sender == _provider);
        
        medications[index].approved[_provider] = true;
    }
    
}



/*
pragma solidity ^0.4.17;

contract HealthRecordFactory{
    address[] public deployedHealthRecords;
    mapping(address => bool) hasDeployedRecord;
    
    struct Provider{
        string name;
        string location;
        address provider;
        mapping(address => bool) patients;
    }
    
    Provider[] public providers;
    mapping(address => bool) providers_map;
    
    
    function createHealthRecord(string name) public {
        require(!hasDeployedRecord[msg.sender]);

        address newHealthRecord = new HealthRecord(name, msg.sender, address(this));
        deployedHealthRecords.push(newHealthRecord);
        
        hasDeployedRecord[msg.sender] = true;
    }

    function getDeployedRecords() public view returns(address[]) {
        return deployedHealthRecords;
    }
    
    function HealthProvider(string name, string location) public {
        Provider memory newProvider = Provider({
            name: name,
            location: location,
            provider: msg.sender
        });
        
        providers.push(newProvider);
        providers_map[msg.sender] = true;
        delete(newProvider);
    }

    function getProviderLength() public constant returns(uint) {
        return providers.length;
    }    
    
    function addPatientToProvider(uint index, address _patient) public {
        Provider storage provider = providers[index];
        provider.patients[_patient] = true;
    }
    
    function getPatientOfProvider(uint index, address _patient) public view returns(bool) {
        Provider storage provider = providers[index];
        return provider.patients[_patient];
    }
    
}




contract HealthRecord{
    string public username;
    address public owner;
    address public factory;
    
    struct Condition{
        string name;
        string status;
        string start_date;
        string end_date;
        string how_it_ended;
        address provider;
        mapping(address => bool) approved;
    }
    
    struct Medication{
        string name;
        string strength;
        string dosage;
        uint how_often;
        string reason;
        string start_date;
        string end_date;
        address provider;
        mapping(address => bool) approved;
    }
    
    struct Appointment{
        address provider;
        string date;
        string purpose;
        mapping(address => bool) approved;
    }
    
    
    Condition[] public conditions;
    Medication[] public medications;
    Appointment[] public appointments;
    
    
    function HealthRecord(string _username, address creator, address _factory) public{
        username = _username;
        owner = creator;
        factory = _factory;
    }
    
    modifier restricted() {
        require(msg.sender == owner);
        _;
    }
    
    function addPatientToProviderFactory(uint index) restricted public {
        HealthRecordFactory newFactory = HealthRecordFactory(factory);
        newFactory.addPatientToProvider(index, owner);
    }
    
    function createCondition
        (   
            string name,
            string status,
            string start_date,
            string end_date,
            string how_it_ended,
            address provider
        )
    public restricted {
        Condition memory newCondition = Condition({
            name: name,
            status: status,
            start_date: start_date,
            end_date: end_date,
            how_it_ended: how_it_ended,
            provider: provider
        });
        
        conditions.push(newCondition);
    }
    
    function createMedication
        (   
            string name,
            string strength,
            string dosage,
            uint how_often,
            string reason,
            string start_date,
            string end_date,
            address provider
        )
    public restricted {
        Medication memory newMedication = Medication({
            name: name,
            strength: strength,
            dosage: dosage,
            how_often: how_often,
            reason: reason,
            start_date: start_date,
            end_date: end_date,
            provider: provider
        });
        
        medications.push(newMedication);
    }
    
    function createAppointment
        (   
            address provider,
            string date,
            string purpose
        )
    public restricted {
        Appointment memory newAppointment = Appointment({
            provider: provider,
            date: date,
            purpose: purpose
        });
        
        appointments.push(newAppointment);
    }
    
    
    function getConditionsLength() public constant restricted returns(uint) {
        return conditions.length;
    }

    function getConditions(uint index) public constant restricted returns(string,string,string,string,string,address,bool) {
        address _provider = conditions[index].provider;
        return (conditions[index].name, conditions[index].status, conditions[index].start_date, conditions[index].end_date,
            conditions[index].how_it_ended, conditions[index].provider,conditions[index].approved[_provider]);
    }
    
    
    function getMedicationsLength() public constant restricted returns(uint) {
        return medications.length;
    }

    function getMedications(uint index) public constant restricted returns(string,string,string,string,string,address,bool) {
        address _provider = medications[index].provider;
        return (medications[index].name,medications[index].strength,medications[index].reason,medications[index].start_date, medications[index].end_date,medications[index].provider,medications[index].approved[_provider]);
    }
    
    function getAppointmentLength() public constant restricted returns(uint) {
        return appointments.length;
    }

    function getAppointment(uint index) public constant restricted returns(address,string,string,bool) {
        address _provider = appointments[index].provider;
        return (appointments[index].provider,appointments[index].date,appointments[index].purpose,appointments[index].approved[_provider]);
    }
    
    function approveCondition(uint index) public {
        address _provider = conditions[index].provider;
        require(msg.sender == _provider);
        
        conditions[index].approved[_provider] = true;
    }
    
    function approveAppointment(uint index) public {
        address _provider = appointments[index].provider;
        require(msg.sender == _provider);
        
        appointments[index].approved[_provider] = true;
    }
    
    function approveMedication(uint index) public {
        address _provider = medications[index].provider;
        require(msg.sender == _provider);
        
        medications[index].approved[_provider] = true;
    }
    
}
*/


/*
pragma solidity ^0.4.17;

contract HealthRecordFactory{
    address[] public deployedHealthRecords;
    mapping(address => bool) hasDeployedRecord;
    
    struct Provider{
        string name;
        string location;
        address provider;
        mapping(address => bool) patients;
    }
    
    Provider[] public providers;
    mapping(address => bool) providers_map;
    
    
    function createHealthRecord(string name) public {
        require(!hasDeployedRecord[msg.sender]);

        address newHealthRecord = new HealthRecord(name, msg.sender, address(this));
        deployedHealthRecords.push(newHealthRecord);
        
        hasDeployedRecord[msg.sender] = true;
    }

    function getDeployedRecords() public view returns(address[]) {
        return deployedHealthRecords;
    }
    
    function HealthProvider(string name, string location) public {
        Provider memory newProvider = Provider({
            name: name,
            location: location,
            provider: msg.sender
        });
        
        providers.push(newProvider);
        providers_map[msg.sender] = true;
        delete(newProvider);
    }

    function getProviderLength() public constant returns(uint) {
        return providers.length;
    }    
    
    function addPatientToProvider(uint index, address _patient) public {
        Provider storage provider = providers[index];
        provider.patients[_patient] = true;
    }
    
    function getPatientOfProvider(uint index, address _patient) public view returns(bool) {
        Provider storage provider = providers[index];
        return provider.patients[_patient];
    }
    
}




contract HealthRecord{
    string public username;
    address public owner;
    address public factory;
    
    struct Condition{
        string name;
        string status;
        string start_date;
        string end_date;
        string how_it_ended;
        address provider;
        mapping(address => bool) approved;
    }
    
    struct Medication{
        string name;
        uint strength;
        uint dosage;
        uint how_often;
        string reason;
        string start_date;
        string end_date;
        address provider;
        mapping(address => bool) approved;
    }
    
    struct Appointment{
        address provider;
        string date;
        string purpose;
        mapping(address => bool) approved;
    }
    
    
    Condition[] public conditions;
    Medication[] public medications;
    Appointment[] public appointments;
    
    
    function HealthRecord(string _username, address creator, address _factory) public{
        username = _username;
        owner = creator;
        factory = _factory;
    }
    
    modifier restricted() {
        require(msg.sender == owner);
        _;
    }
    
    function addPatientToProviderFactory(uint index) restricted public {
        HealthRecordFactory newFactory = HealthRecordFactory(factory);
        newFactory.addPatientToProvider(index, owner);
    }
    
    function createCondition
        (   
            string name,
            string status,
            string start_date,
            string end_date,
            string how_it_ended,
            address provider
        )
    public restricted {
        Condition memory newCondition = Condition({
            name: name,
            status: status,
            start_date: start_date,
            end_date: end_date,
            how_it_ended: how_it_ended,
            provider: provider
        });
        
        conditions.push(newCondition);
    }
    
    function createMedication
        (   
            string name,
            uint strength,
            uint dosage,
            uint how_often,
            string reason,
            string start_date,
            string end_date,
            address provider
        )
    public restricted {
        Medication memory newMedication = Medication({
            name: name,
            strength: strength,
            dosage: dosage,
            how_often: how_often,
            reason: reason,
            start_date: start_date,
            end_date: end_date,
            provider: provider
        });
        
        medications.push(newMedication);
    }
    
    function createAppointment
        (   
            address provider,
            string date,
            string purpose
        )
    public restricted {
        Appointment memory newAppointment = Appointment({
            provider: provider,
            date: date,
            purpose: purpose
        });
        
        appointments.push(newAppointment);
    }
    
    
    function getConditionsLength() public constant restricted returns(uint) {
        return conditions.length;
    }

    function getConditions(uint index) public constant restricted returns(string,string,string,string,string,address,bool) {
        address _provider = conditions[index].provider;
        return (conditions[index].name, conditions[index].status, conditions[index].start_date, conditions[index].end_date,
            conditions[index].how_it_ended, conditions[index].provider,conditions[index].approved[_provider]);
    }
    
    
    function getMedicationsLength() public constant restricted returns(uint) {
        return medications.length;
    }

    function getMedications(uint index) public constant restricted returns(string,uint,string,string,string,address,bool) {
        address _provider = medications[index].provider;
        return (medications[index].name,medications[index].strength,medications[index].reason,medications[index].start_date, medications[index].end_date,medications[index].provider,medications[index].approved[_provider]);
    }
    
    function getAppointmentLength() public constant restricted returns(uint) {
        return appointments.length;
    }

    function getAppointment(uint index) public constant restricted returns(address,string,string,bool) {
        address _provider = appointments[index].provider;
        return (appointments[index].provider,appointments[index].date,appointments[index].purpose,appointments[index].approved[_provider]);
    }
    
    function approveCondition(uint index) public {
        address _provider = conditions[index].provider;
        require(msg.sender == _provider);
        
        conditions[index].approved[_provider] = true;
    }
    
    function approveAppointment(uint index) public {
        address _provider = appointments[index].provider;
        require(msg.sender == _provider);
        
        appointments[index].approved[_provider] = true;
    }
    
    function approveMedication(uint index) public {
        address _provider = medications[index].provider;
        require(msg.sender == _provider);
        
        medications[index].approved[_provider] = true;
    }
    
}
*/