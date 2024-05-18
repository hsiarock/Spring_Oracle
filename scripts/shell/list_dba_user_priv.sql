

SELECT
    "A1"."GRANTEE"            "GRANTEE",
    "A1"."GRANTED_ROLE"       "GRANTED_ROLE",
    "A1"."ADMIN_OPTION"       "ADMIN_OPTION",
    "A1"."DELEGATE_OPTION"    "DELEGATE_OPTION",
    "A1"."DEFAULT_ROLE"       "DEFAULT_ROLE",
    "A1"."COMMON"             "COMMON",
    "A1"."INHERITED"          "INHERITED"
FROM
    (
        ( SELECT /*+ INDEX ("A14" "I_SYSAUTH1") */ decode("A14"."GRANTEE#", 1, 'PUBLIC', "A13"."NAME")                                    "GRANTEE",
            "A12"."NAME"                                                                        "GRANTED_ROLE",
            decode(MIN(bitand(nvl("A14"."OPTION$", 0), 1)), 1, 'YES', 'NO')                          "ADMIN_OPTION",
            decode(MIN(bitand(nvl("A14"."OPTION$", 0), 2)), 2, 'YES', 'NO')                          "DELEGATE_OPTION",
            decode(MIN("A13"."DEFROLE"), 0, 'NO', 1, decode(MIN("A12"."PASSWORD"), NULL, decode(MIN("A12"."SPARE4"), NULL, 'YES',
            'NO'), 'NO'),
                   2,
                   decode(MIN("A11"."ROLE#"), NULL, 'NO', decode(MIN("A12"."PASSWORD"), NULL, decode(MIN("A12"."SPARE4"), NULL, 'YES',
                   'NO'), 'NO')),
                   3,
                   decode(MIN("A11"."ROLE#"), NULL, decode(MIN("A12"."PASSWORD"), NULL, decode(MIN("A12"."SPARE4"), NULL, 'YES', 'NO'),
                   'NO'),
                          'NO'),
                   'NO')                                                                        "DEFAULT_ROLE",
            'NO'                                                                                "COMMON",
            'NO'                                                                                "INHERITED"
        FROM
            "SYS"."SYSAUTH$"    "A14",
            "SYS"."USER$"       "A13",
            "SYS"."USER$"       "A12",
            "SYS"."DEFROLE$"    "A11"
        WHERE
                "A14"."GRANTEE#" = "A11"."USER#" (+)
            AND "A14"."PRIVILEGE#" = "A11"."ROLE#" (+)
            AND "A13"."USER#" = "A14"."GRANTEE#"
            AND "A12"."USER#" = "A14"."PRIVILEGE#"
            AND bitand(nvl("A14"."OPTION$", 0), 4) = 0
        GROUP BY
            decode("A14"."GRANTEE#", 1, 'PUBLIC', "A13"."NAME"),
            "A12"."NAME"
        )
        UNION ALL
        ( SELECT /*+ INDEX ("A10" "I_SYSAUTH1") */ decode("A10"."GRANTEE#", 1, 'PUBLIC', "A9"."NAME")                                       "GRANTEE",
            "A8"."NAME"                                                                           "GRANTED_ROLE",
            decode(MIN(bitand(nvl("A10"."OPTION$", 0), 16)), 16, 'YES', 'NO')                          "ADMIN_OPTION",
            decode(MIN(bitand(nvl("A10"."OPTION$", 0), 32)), 32, 'YES', 'NO')                          "DELEGATE_OPTION",
            decode(MIN("A9"."DEFROLE"), 0, 'NO', 1, decode(MIN("A8"."PASSWORD"), NULL, decode(MIN("A8"."SPARE4"), NULL, 'YES', 'NO'),
            'NO'),
                   2,
                   decode(MIN("A7"."ROLE#"), NULL, 'NO', decode(MIN("A8"."PASSWORD"), NULL, decode(MIN("A8"."SPARE4"), NULL, 'YES',
                   'NO'), 'NO')),
                   3,
                   decode(MIN("A7"."ROLE#"), NULL, decode(MIN("A8"."PASSWORD"), NULL, decode(MIN("A8"."SPARE4"), NULL, 'YES', 'NO'),
                   'NO'),
                          'NO'),
                   'NO')                                                                          "DEFAULT_ROLE",
            'YES'                                                                                 "COMMON",
            decode(sys_context('USERENV', 'CON_ID'), 1, 'NO', 'YES')                                  "INHERITED"
        FROM
            "SYS"."SYSAUTH$"    "A10",
            "SYS"."USER$"       "A9",
            "SYS"."USER$"       "A8",
            "SYS"."DEFROLE$"    "A7"
        WHERE
                "A10"."GRANTEE#" = "A7"."USER#" (+)
            AND "A10"."PRIVILEGE#" = "A7"."ROLE#" (+)
            AND "A9"."USER#" = "A10"."GRANTEE#"
            AND "A8"."USER#" = "A10"."PRIVILEGE#"
            AND bitand(nvl("A10"."OPTION$", 0), 8) = 8
        GROUP BY
            decode("A10"."GRANTEE#", 1, 'PUBLIC', "A9"."NAME"),
            "A8"."NAME"
        )
        UNION ALL
        ( SELECT /*+ INDEX ("A6" "I_SYSAUTH1") */ decode("A6"."GRANTEE#", 1, 'PUBLIC', "A5"."NAME")                                         "GRANTEE",
            "A4"."NAME"                                                                            "GRANTED_ROLE",
            decode(MIN(bitand(nvl("A6"."OPTION$", 0), 128)), 128, 'YES', 'NO')                          "ADMIN_OPTION",
            decode(MIN(bitand(nvl("A6"."OPTION$", 0), 256)), 256, 'YES', 'NO')                          "DELEGATE_OPTION",
            decode(MIN("A5"."DEFROLE"), 0, 'NO', 1, decode(MIN("A4"."PASSWORD"), NULL, decode(MIN("A4"."SPARE4"), NULL, 'YES', 'NO'),
            'NO'),
                   2,
                   decode(MIN("A3"."ROLE#"), NULL, 'NO', decode(MIN("A4"."PASSWORD"), NULL, decode(MIN("A4"."SPARE4"), NULL, 'YES',
                   'NO'), 'NO')),
                   3,
                   decode(MIN("A3"."ROLE#"), NULL, decode(MIN("A4"."PASSWORD"), NULL, decode(MIN("A4"."SPARE4"), NULL, 'YES', 'NO'),
                   'NO'),
                          'NO'),
                   'NO')                                                                           "DEFAULT_ROLE",
            'YES'                                                                                  "COMMON",
            decode(sys_context('USERENV', 'IS_APPLICATION_PDB'), 'YES', 'YES', 'NO')                   "INHERITED"
        FROM
            "SYS"."SYSAUTH$"    "A6",
            "SYS"."USER$"       "A5",
            "SYS"."USER$"       "A4",
            "SYS"."DEFROLE$"    "A3"
        WHERE
                "A6"."GRANTEE#" = "A3"."USER#" (+)
            AND "A6"."PRIVILEGE#" = "A3"."ROLE#" (+)
            AND "A5"."USER#" = "A6"."GRANTEE#"
            AND "A4"."USER#" = "A6"."PRIVILEGE#"
            AND bitand(nvl("A6"."OPTION$", 0), 64) = 64
        GROUP BY
            decode("A6"."GRANTEE#", 1, 'PUBLIC', "A5"."NAME"),
            "A4"."NAME"
        )
    ) "A1"
WHERE
    "A1"."GRANTEE" IN ('SYS', 'SYSDBA', 'SYSTEM');