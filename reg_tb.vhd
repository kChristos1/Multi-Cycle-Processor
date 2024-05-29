LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.array_pack.ALL;

ENTITY reg_tb IS
END reg_tb;

ARCHITECTURE behavior OF reg_tb IS
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT REG
        PORT (
            reg_clk : IN  STD_LOGIC;
            Data    : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
            Dout    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            WE      : IN  STD_LOGIC;
            reset   : IN  STD_LOGIC
        );
    END COMPONENT;
    --Inputs
    SIGNAL reg_clk          : STD_LOGIC                     := '0';
    SIGNAL Data             : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL WE               : STD_LOGIC                     := '0';
    SIGNAL reset            : STD_LOGIC                     := '0';
    --Outputs
    SIGNAL Dout             : STD_LOGIC_VECTOR(31 DOWNTO 0);
    -- Clock period definitions
    CONSTANT reg_clk_period : TIME := 10 ns;
BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut : REG PORT MAP(
        reg_clk => reg_clk,
        Data    => Data,
        Dout    => Dout,
        WE      => WE,
        reset   => reset
    );

    -- Clock process definitions
    reg_clk_process : PROCESS
    BEGIN
        reg_clk <= '0';
        WAIT FOR reg_clk_period/2;
        reg_clk <= '1';
        WAIT FOR reg_clk_period/2;
    END PROCESS;

    -- Stimulus process
    stim_proc : PROCESS
    BEGIN
        -- hold reset state
        reset <= '1'; -- so Dout is zero
        WAIT FOR reg_clk_period;

        -- unable to write Data so Dout still zero
        reset <= '0';
        WE    <= '0';
        Data  <= (OTHERS => '1');
        WAIT FOR reg_clk_period;

        -- able to write Data so Dout = Data
        reset <= '0';
        WE    <= '1';
        Data  <= (OTHERS => '1');
        WAIT FOR reg_clk_period;
    END PROCESS;
END;
