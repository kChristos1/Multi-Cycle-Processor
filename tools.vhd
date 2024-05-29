LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

PACKAGE array_pack IS
       -- 32-length array of 32-bit numbers
       TYPE array_32 IS ARRAY (31 DOWNTO 0) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
       
       -- 32-length array of 1-bit
       TYPE array_1 IS ARRAY (31 DOWNTO 0) OF STD_LOGIC;
END array_pack;
