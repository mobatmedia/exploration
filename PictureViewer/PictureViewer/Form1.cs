// Copyright 2016 Mario O. Bourgoin
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace PictureViewer
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void clearButton_Click(object sender, EventArgs e)
        {
            // Clear the picture, if any.
            pictureBox1.Image = null;
        }

        private void showButton_Click(object sender, EventArgs e)
        {
            // Show the OpenFile dialog. If the user clicks OK,
            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                // load the picture the user chose.
                pictureBox1.Load(openFileDialog1.FileName);
            }
        }

        private void backgroundButton_Click(object sender, EventArgs e)
        {
            // Show the ColorDialog dialog. If the user clicks OK,
            if (colorDialog1.ShowDialog() == DialogResult.OK)
            {
                // load the picture the user chose.
                pictureBox1.BackColor = colorDialog1.Color;
            }
        }

        private void closeButton_Click(object sender, EventArgs e)
        {
            // Close the form.
            this.Close();
        }

        private void checkBox1_CheckedChanged(object sender, EventArgs e)
        {
            // The user has changed the checkbox's state. If it is checked,
            if (checkBox1.Checked)
            {
                pictureBox1.SizeMode = PictureBoxSizeMode.StretchImage;
            }
            else
            {
                pictureBox1.SizeMode = PictureBoxSizeMode.Normal;
            }
        }
    }
}