pragma solidity ^0.4.10;

contract RoleBasedAcl {
  address owner;
  mapping(address => mapping(string => bool)) roles;

  function RoleBasedAcl () {
    owner = msg.sender;
  }

  function assign (address entity, string role) hasRole('superadmin') {
    roles[entity][role] = true;
  }

  function unassign (address entity, string role) hasRole('superadmin') {
    roles[entity][role] = false;
  }

  function isAssigned (address entity, string role) returns (bool) {
    return roles[entity][role];
  }

  modifier hasRole (string role) {
    if (!roles[msg.sender][role] && msg.sender != owner) {
      throw;
    }
    _;
  }
}
