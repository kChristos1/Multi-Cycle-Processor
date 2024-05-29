LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY MEMSTAGE_tb IS
END MEMSTAGE_tb;

ARCHITECTURE behavior OF MEMSTAGE_tb IS
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT MEMSTAGE
        PORT (
            clk          : IN  STD_LOGIC;
            Mem_WrEn     : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
            ALU_MEM_Addr : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
            MEM_DataIn   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
            MEM_DataOut  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    --Inputs
    SIGNAL clk          : STD_LOGIC                     := '0';
    SIGNAL Mem_WrEn     : STD_LOGIC_VECTOR(0 DOWNTO 0)  := (OTHERS => '0');
    SIGNAL ALU_MEM_Addr : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL MEM_DataIn   : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    --Outputs
    SIGNAL MEM_DataOut  : STD_LOGIC_VECTOR(31 DOWNTO 0);
    -- Clock period definitions
    CONSTANT clk_period : TIME := 10 ns;
BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut : MEMSTAGE PORT MAP(
        clk          => clk,
        Mem_WrEn     => Mem_WrEn,
        ALU_MEM_Addr => ALU_MEM_Addr,
        MEM_DataIn   => MEM_DataIn,
        MEM_DataOut  => MEM_DataOut
    );
    -- Clock process definitions
    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period/2;
        clk <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;
    -- Stimulus process
    stim_proc : PROCESS
    BEGIN
        -- MEM_WrEn defines operation:
        -- read  -> 0
        -- write -> 1
        
        -- write something...
        Mem_WrEn     <= "1";
        ALU_MEM_Addr <= "00000000000000000000000101011111";
        MEM_DataIn   <= "00001001110101111100001100111101";
        WAIT FOR clk_period;

        --and then read from the same address
        Mem_WrEn     <= "0";
        ALU_MEM_Addr <= "00000000000000000000000101011111";
        MEM_DataIn   <= "11111111111111111111111111111111";
        WAIT FOR clk_period;
    END PROCESS;
END;
