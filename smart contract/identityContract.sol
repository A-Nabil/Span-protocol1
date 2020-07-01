pragma solidity ^0.6.1;

contract IdentityContract {
  string myName = "Tristan";
mapping(string => string) public users; // users of the system
mapping(address => string) public controlles; // controlles
mapping(string => string) public fogNodes; // fogNodes
mapping(string => string) public devices; // IoT devices
mapping(string => mapping(string => string)) public users_devices; // mapping for users and their accessable devices

address cloudServerAddress;

constructor() public
{
cloudServerAddress = msg.sender;
}

modifier onlyCloudServer()
{
   require(cloudServerAddress == msg.sender,"Sender not authorized.");
   _;
}
modifier onlyControllers()
{
  require(bytes(controlles[msg.sender]).length == 0,"Sender not authorized.");
        _;
}

    //add user
    function addUser(string memory id,string memory jsonld) public onlyCloudServer {
    require(bytes(users[id]).length == 0,"user exists");
    users[id] = jsonld;
    }
    
    //Add controller
    function addController(address id,string memory jsonld) public onlyCloudServer {
      require(bytes(controlles[id]).length == 0,"controller exists");
       controlles[id] = jsonld;
    }
    //Add Fog node
    function addFogNodes(string memory id,string memory jsonld) public onlyControllers {
      require(bytes(fogNodes[id]).length == 0,"node exists");
      fogNodes[id] = jsonld;
    }

    //Add user device
    function addUserDevice(string memory userId,string memory deviceId, string memory deviceJsonld ) public onlyCloudServer
    {
        //Check if user exists
         require(bytes(users[userId]).length != 0,"user dosn't exists");
        //check if device already added
        require(bytes(users_devices[userId][deviceId]).length == 0,"device assigned to this user before");
        //add device to user's devices
        users_devices[userId][deviceId] = deviceJsonld;
    }

function stringsEqual(string storage _a, string memory _b) internal view returns (bool)
{
  bytes storage a = bytes(_a); bytes memory b = bytes(_b);
  if (a.length != b.length)
  return false; // @todo unroll this loop
  for (uint i = 0; i < a.length; i ++) if (a[i] != b[i]) return false; return true;
}


}
