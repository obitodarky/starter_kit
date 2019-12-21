pragma solidity ^0.5.0;


contract CropMarket {
    uint public cropCount = 0;
    struct Crop{
        address owner;
        uint256 quantity;
        uint256 price;
        uint256 cropId;
    }
    
    mapping(uint256 => Crop) public crops;
    
    struct Transaction{
        uint256 cropId;
        address user;
        uint256 quantity;
    }
    
    uint256 public transactionId;
    mapping(uint256 => Transaction) public trasanctions;
    
    struct User{
        uint256 quantity;
    }
    
    uint256 public userId;
    mapping(uint256 => User) public users;
    
    event NewCrop(
        uint256 indexed cropId
    );
    
    event NewTransaction(
        uint256 cropId,
        uint256 transactionId
    );
    
    function releaseStock(uint256 quantity, uint256 price) public {
        cropCount++;
        crops[cropCount] = Crop(msg.sender,quantity, price,cropCount);
        emit NewCrop(cropCount);
    }
    
    function purchaseStock(uint256 cropid, uint256 quantity) public payable{
        Crop storage crop = crops[cropid];
        require(
            quantity < crop.quantity,
            "Not enough quantity"
        );
        
        require(
            msg.value==crop.price*quantity,
            "Not enough balance"
        );
        
        _sendFunds(crop.owner, msg.value);
        refilStock(cropid, quantity);
    }
    
    function refilStock(uint256 cropid, uint256 quantity) internal {
        trasanctions[transactionId] = Transaction(cropid,msg.sender,quantity);
        Crop storage crop = crops[cropid];
        crop.quantity = crop.quantity - quantity;
        emit NewTransaction(cropid, transactionId++);
    }
    
    function _sendFunds(address rec, uint256 value) internal{
        address(uint160(rec)).transfer(value);
    }
}