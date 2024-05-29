LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY MEMSTAGE IS
    PORT (
        clk          : IN  STD_LOGIC;
        Mem_WrEn     : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
        ALU_MEM_Addr : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
        MEM_DataIn   : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
        MEM_DataOut  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
END MEMSTAGE;

ARCHITECTURE Behavioral OF MEMSTAGE IS
    COMPONENT ram_memory IS
        PORT (
            WEA   : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
            ADDRA : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
            DINA  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
            DOUTA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            CLKA  : IN  STD_LOGIC
        );
    END COMPONENT;
BEGIN
    MEM : ram_memory PORT MAP(
        WEA   => Mem_WrEn,
        ADDRA => ALU_MEM_Addr(9 DOWNTO 0),
        DINA  => MEM_DataIn,
        DOUTA => MEM_DataOut,
        CLKA  => clk
    );
END Behavioral;
