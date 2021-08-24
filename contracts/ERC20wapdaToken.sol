// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC20_wapda.sol";

contract ERC20 is IERC20{
    mapping (address => uint) private _balances;
    mapping (address => mapping(address => uint )) private _allowances;
   
    uint private _totalsupply;
    string private name;
    string private symbol;
    uint private decimals;
    uint internal lockTime;
    
    address internal owner;
    address private contractAddress;
    // event TokenDetails(string, string, uint, address, address);
   
    
    constructor() {
        name = "WAPDA Ecosystem Token";
        symbol = "WET";
        decimals = 18;
        owner = msg.sender;
        contractAddress = address(this);
        lockTime = 120 + block.timestamp; //2629743 = one month 
        
        _totalsupply = 21000000 * 10**decimals;
        _balances[owner] = _totalsupply;
        
        // emit TokenDetails(name, symbol,decimals, owner, contractAddress);
        // emit Transfer(address(this),owner,_totalsupply);
    }
    
    modifier isTimeLock(){
        require(block.timestamp > lockTime,"Wait for the vesting time");
        _;
    } 
    
    function totalSupply()public view virtual override returns(uint){
        return _totalsupply;
    }
    
    function getTokenDetails()public view returns(
        string memory Name, 
        string memory Symbol, 
        uint Decimals, 
        address Owner,
        address ContractAddress)
    {
        return (name, symbol, decimals, owner, contractAddress);
    }
    
    function balanceOf(address account) public view virtual override returns(uint){
        return _balances[account];
    }
    
    function transfer(address recipient, uint amount)public virtual override returns(bool){
        _transfer(msg.sender, recipient, amount);
            return true;
   
    }
    
      function _transfer(address sender, address recipient, uint amount)internal virtual isTimeLock returns(bool){
        require(sender != address(0), "sender is not valid address");
        require(recipient != address(0), "recipient is not valid address");
        require(_balances[sender] > amount,"insufficient balance");
        
      _balances[sender] -= amount; 
      _balances[recipient] += amount;
      
        emit Transfer(sender, recipient, amount);
        return true;
    }
    
    
    function buyTokens(address recipient, uint amount)internal virtual isTimeLock returns(bool){
        require(msg.sender != address(0), "sender is not valid address");
        require(recipient != address(0), "recipient is not valid address");
        
      _balances[owner] -= amount; 
      _balances[recipient] += amount;
      
        emit Transfer(owner, recipient, amount);
        return true;
    
    }  
    
    
    function mint(address account, uint _mint)internal virtual isTimeLock returns(bool){
        require(account != address(0) && _mint > 0,"unauthorized call");
        _totalsupply += _mint*10**decimals;
        _balances[account] += _mint*10**decimals;
        return true;
    }

    function approve(address spender, uint amount)public virtual override returns(bool){
        address tokenOwner = msg.sender;
        
        require(msg.sender == owner,"unauthorized call");
        require(_balances[owner] > amount,"insufficient funds");
        require(tokenOwner != address(0), "tokenOwner is not valid address");
        require(spender != address(0), "spender is not valid address");
        
        _allowances[tokenOwner][spender] = amount;
        emit Approval(tokenOwner,spender,amount);
        return true;
    }
    
    function allowance(address tokenOwner, address spender)public virtual override view returns(uint){
        return _allowances[tokenOwner][spender];
    }
    
    function transferFrom(address tokenOwner, address recipient, uint amount)public virtual override isTimeLock returns(bool){
        address spender = msg.sender;
        uint value = _allowances[tokenOwner][spender];
        require(value > amount,"insufficient funds");
        require(recipient != address(0), "recipient is not valid address");
        
        _allowances[tokenOwner][spender] -= amount;
        _balances[owner] -= amount;
        _balances[recipient] += amount;
        
        emit Transfer(tokenOwner, recipient, amount);
        return true;
        
    }
    
}